//
//  Response.swift
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

public class Response: ResponseProtocol {

    /// Type of response
    ///
    /// - success: success
    /// - error: error
    public enum StatusResult {
        case success(_: Int)
        case error(_: Int)
        case noResponse

        private static let successCodes: Range<Int> = 200..<399

        public static func from(response: HTTPURLResponse?) -> StatusResult {
            guard let res = response else {
                return .noResponse
            }
            return (StatusResult.successCodes.contains(res.statusCode) ? .success(res.statusCode) : .error(res.statusCode))
        }

        public var code: Int? {
            switch self {
            case .success(let code):
                return code
            case .error(let code):
                return code
            case .noResponse:
                return nil
            }
        }
    }

    /// Type of result
    public let type: Response.StatusResult

    /// Status code of the response
    public var httpStatusCode: Int? {
        return self.type.code
    }

    /// HTTPURLResponse
    public let httpResponse: HTTPURLResponse?

    /// Raw data of the response
    public var data: Data?

    /// Request executed
    public let request: RequestProtocol

    /// Metrics of the request/response to make benchmarks
    public var metrics: ResponseTimeline?

    /// Initialize a new response from Alamofire response
    ///
    /// - Parameters:
    ///   - response: response
    ///   - request: request
    public init(urlResponse: HTTPURLResponse?, data: Data?, request: RequestProtocol) {
        self.type = StatusResult.from(response: urlResponse)
        self.httpResponse = urlResponse
        self.data = data
        self.request = request
    }

    public func toJSON() -> JSON {
        return self.cachedJSON
    }

    public func toString(_ encoding: String.Encoding? = nil) -> String? {
        guard let data = self.data else {
            return nil
        }
        return String(data: data, encoding: encoding ?? .utf8)
    }
    
    private lazy var cachedJSON: JSON = {
        do {
             return try JSON(data: self.data ?? Data())
        } catch let error {
            return JSON()
        }
        //return try! JSON(data: self.data ?? Data())
    }()
}
