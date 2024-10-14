//
//  Service.swift
//
//  Original article:        http://danielemargutti.com/2017/09/09/network-layers-in-swift-updated/
//    Created by:                Daniele Margutti
//
//
//    Permission is hereby granted, free of charge, to any person obtaining a copy
//    of this software and associated documentation files (the "Software"), to deal
//    in the Software without restriction, including without limitation the rights
//    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//    copies of the Software, and to permit persons to whom the Software is
//    furnished to do so, subject to the following conditions:
//
//    The above copyright notice and this permission notice shall be included in
//    all copies or substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//    THE SOFTWARE.
import Foundation
import SwiftyJSON
import Combine

/// Service is a concrete implementation of the ServiceProtocol
public class Service: NSObject, ServiceProtocol {

    let token: String? = UserDefaults.accessToken
    let refreshToken: String? = UserDefaults.refreshToken

    var bag = Set<AnyCancellable>()

    static var shared: Service = {
        return getInstance()
    }()

    /// Configuration
    public var configuration: ServiceConfig

    /// Session headers
    public var headers: HeadersDict

    private lazy var session: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 120
        configuration.timeoutIntervalForResource = 120
        return URLSession(configuration: configuration,
                          delegate: nil, delegateQueue: nil)
    }()

    /// Initialize a new service with given configuration
    ///
    /// - Parameter configuration: configuration. If `nil` is passed attempt to load configuration from your app's Info.plist
    public required init(_ configuration: ServiceConfig) {
        self.configuration = configuration
        headers = self.configuration.headers // fillup with initial headers
        if let token = token {
            headers["Authorization"] = "Bearer \(token)"
        }
        self.headers["Content-Type"] = "application/json"
    }

    static func getInstance() -> Service {
        guard let config = ServiceConfig.appConfig() else {
            let appCfg = JSON(Bundle.main.object(forInfoDictionaryKey: ConstantConfigs.ServerConfig.endpoint.rawValue) as Any)
            let myConfig = ServiceConfig(base: appCfg[ConstantConfigs.ServerConfig.base.rawValue].string ?? Bundle.main.infoDictionary?["base"] as! String)
            return Service(myConfig!)
        }
        return Service(config)
    }

    /// Execute a request and return a Observable with the response
    ///
    /// - Parameters:
    ///   - request: request to execute
    ///   - retry: retry attempts. If `nil` only one attempt is made. Default value is `nil`.
    /// - Returns: AnyPublisher
    /// - Throws: throw an exception if operation cannot be executed
    public func execute(_ request: RequestProtocol, retry: Int) throws -> AnyPublisher<Data, APIError> {
        let urlRequest = try request.urlRequest(in: self)
        let cancelable = session.dataTaskPublisher(for: urlRequest)
            .retry(retry)
            .tryMap { [weak self] element -> Data in
                guard let httpResponse = element.response as? HTTPURLResponse else {
                    throw APIError.unknown
                }

                switch httpResponse.statusCode {
                case 200..<399:
                    let json = JSON(element.data)
                    if json["data"].rawValue is Bool {
                      return json["data"].toData() ?? Data()
                    }
                    if json["data"].rawValue is String {
                        return json["data"].toData() ?? Data()
                    }
                    if  json["data"].rawValue is NSNull { // google services return NSNull in data
                        return try json.rawData()
                    }
                    return try json["data"].rawData()
                case 401:
                    //TODO: Navigate to login or start over again.
                    guard let self = self else { return Data() }
                    try self.renewToken()
                    self.session.getAllTasks { tasks in
                        tasks.forEach { $0.cancel() }
                        do {
                            try self.renewToken()
                        } catch {
                        }
                    }
                    throw APIError.unathurizedError(reason: Localizable.unathurizedError(preferredLanguages: LanguageManager.shared.preferredLanguages))
                case 422:
                    let json = JSON(element.data)
                    var reason = ""
                    if let arr = json["data"].arrayObject as? [String] {
                        arr.forEach { reason.append($0 + "\n") }
                    } else {
                       reason = json["data"].stringValue
                    }
                    throw APIError.validationError(reason: reason)
                case 402..<407, 409..<499:
                    let json = JSON(element.data)
                    throw APIError.apiError(reason: json["data"].stringValue)
                case 408: // Request Timeout
                    throw APIError.serviceUnavailable
                case 500:
                    throw APIError.internalServerError
                case 503: //Service Unavailable
                    throw APIError.serviceUnavailable
                case 500..<502, 504..<599:
                    let json = JSON(element.data)
                    let error = json["data"].stringValue
                    throw APIError.apiError(reason: error.isEmpty ? Localizable.serverSideError(preferredLanguages: LanguageManager.shared.preferredLanguages) : error)
                default:
                    let json = JSON(element.data)
                    throw APIError.parserError(reason: json["data"].stringValue)
                }
        }
        .mapError { error -> APIError in
            if let error = error as? APIError {
                return error
            }

            if let urlerror = error as? URLError {
                if urlerror.code.rawValue == -1009 || urlerror.code.rawValue == -1020 { // connectionError user is offline
                    return APIError.connectionError(from: urlerror)
                }

                if urlerror.code.rawValue == -1200 { // An SSL error
                    return APIError.sslError(from: urlerror)
                }
                if urlerror.code.rawValue == -1001 { // The request timed out
                    return APIError.requestTimeOut
                }
                return APIError.networkError(from: urlerror)
            }

            return APIError.unknown
        }
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
        return cancelable
    }

    func renewToken() throws {
        if let refreshToken = refreshToken {
            let bodyDict = ["refreshToken": refreshToken]
            guard let data = bodyDict.toString() else { return }
            let reqBody = RequestBody.raw(string: data)
            let request = Request(method: .post, endpoint: "/auth/refresh-token", params: nil, fields: nil, body: reqBody)

            let urlRequest = try request.urlRequest(in: self)
            session.dataTaskPublisher(for: urlRequest)
                .tryMap() { element -> Data in
                    guard let httpResponse = element.response as? HTTPURLResponse else {
                        throw URLError(.unknown)
                    }

                    switch httpResponse.statusCode {
                    case 200..<299:
                        let json = JSON(element.data)
                        return try json["data"].rawData()
                    default:
                        throw URLError(.userAuthenticationRequired)
                    }
                }
            .decode(type: UserLogin.self, decoder: JSONDecoder())
                .sink(
                    receiveCompletion: { completion in
                        switch completion {
                        case .finished:
                            break
                        case .failure(_):
                            //TODO: Navigate to login
                            break
                        }
                    },
                    receiveValue: { userLogin in
                        UserDefaults.accessToken = userLogin.accessToken
                        UserDefaults.refreshToken = userLogin.refreshToken
                    }
            ).store(in: &bag)
        }
    }

    deinit {
        bag.forEach { $0.cancel() }
    }
}

//MARK: URLSessionDelegates
extension Service: URLSessionDelegate {
}
