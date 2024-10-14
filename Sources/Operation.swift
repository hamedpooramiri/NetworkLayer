//
//  Operation.swift
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

import Combine
import Foundation
import SwiftyJSON

/// Data operation, return a response via Observable
open class DataOperation<Output: Decodable>: OperationProtocol {

    typealias T = Output

    /// Request to send
    public var request: RequestProtocol?

    /// Init
    public init() {}

    /// Execute the request in a service and return a Observable with server response
    ///
    /// - Parameters:
    ///   - service: service to use
    ///   - retry: retry attempts in case of failure
    /// - Returns: AnyPublisher
    public func execute(in service: ServiceProtocol, retry: Int) -> AnyPublisher<Output, APIError> {
        guard let request = self.request else { // missing request
            return Fail(error: APIError.unknown).eraseToAnyPublisher()
        }

        do {
            return try service.execute(request, retry: retry)
                .tryMap {
                    if let data = $0 as? T {
                        return data
                    } else {
                        throw APIError.parserError(reason: "")
                    }
                }
                .mapError { error -> APIError in
                    return APIError.apiError(reason: error.localizedDescription)
                }
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: APIError.unknown).eraseToAnyPublisher()
        }
    }
}

/// JSON Operation, return a response as JSON
open class JSONOperation<Output: Decodable>: OperationProtocol {

    typealias T = Output

    /// Request
    public var request: RequestProtocol?

    /// Init
    public init() {}

    /// Execute a request and return your specified model `Output`.
    ///
    /// - Parameters:
    ///   - service: service to use
    ///   - retry: retry attempts
    /// - Returns: Observable
    public func execute(retry: Int = 1) -> AnyPublisher<Output, APIError> {
//        if Service.shared.token != nil { //UserDefaults.getUserToken() {
            Service.shared = Service.getInstance()
//        }

        return self.execute(in: Service.shared, retry: retry)
    }

    public func execute(in service: ServiceProtocol, retry: Int) -> AnyPublisher<Output, APIError> {
        guard let request = self.request else { // missing request
            return Fail(error: APIError.unknown).eraseToAnyPublisher()
        }

        do {
            return try service.execute(request, retry: retry)
                .decode(type: Output.self, decoder: JSONDecoder())
                .mapError { error -> APIError in
                    if let error = error as? APIError {
                        return error
                    }
                    return APIError.apiError(reason: error.localizedDescription)
                }
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: APIError.unknown).eraseToAnyPublisher()
        }
    }
}
