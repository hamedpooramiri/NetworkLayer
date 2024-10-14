//
//  DataService.swift
//  Hitrav
//
//  Created by Hamed Pouramiri on 5/20/21.
//  Copyright © 2021 Pixel. All rights reserved.
//

import Combine
import Foundation
import SwiftyJSON

/// Service is a concrete implementation of the ServiceProtocol
public class DataService: NSObject, ServiceProtocol {

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
            .tryMap { element -> Data in
                guard let httpResponse = element.response as? HTTPURLResponse else {
                    throw APIError.unknown
                }

                switch httpResponse.statusCode {
                case 200..<399:
                    return element.data
                default:
                    throw APIError.serviceUnavailable
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
                return APIError.networkError(from: urlerror)
            }

            return APIError.unknown
        }
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
        return cancelable
    }

    deinit {
        bag.forEach { $0.cancel() }
    }
}
