//
//  NetworkError.swift
//  Hitrav
//
//  Created by Amir on 7/31/20.
//  Copyright © 2020 Pixel. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol NetworkErrors: Error {}

public enum NetworkError: NetworkErrors {
    case dataIsNotEncodable(_: Any)
    case stringFailedToDecode(_: Data, encoding: String.Encoding)
    case invalidURL(_: String)
    case error(_: ResponseProtocol)
    case noResponse(_: ResponseProtocol)
    case missingEndpoint
    case failedToParseJSON(_: JSON, _: ResponseProtocol)
}

public enum APIError: Error, LocalizedError {
    case unknown
    case apiError(reason: String)
    case parserError(reason: String)
    case networkError(from: URLError)
    case connectionError(from: URLError)
    case validationError(reason: String)
    case internalServerError
    case serviceUnavailable
    case unathurizedError(reason: String)
    case sslError(from: URLError)
    case requestTimeOut
    public var errorDescription: String? {
        switch self {
        case .unknown:
            return Localizable.unknownError(preferredLanguages: LanguageManager.shared.preferredLanguages)
        case .apiError(let reason), .parserError(let reason):
            return reason
        case .networkError(let from):
            return from.localizedDescription
        case .validationError(let reason):
           return reason.isEmptyOrWhitespace ? Localizable.validationError(preferredLanguages: LanguageManager.shared.preferredLanguages) :
             reason
        case .connectionError(let error), .sslError(let error):
            return error.localizedDescription
        case .unathurizedError(let reason):
            return reason
        case .internalServerError:
            return Localizable.serverSideError(preferredLanguages: LanguageManager.shared.preferredLanguages)
        case .serviceUnavailable:
            return Localizable.serviceUnavailable(preferredLanguages: LanguageManager.shared.preferredLanguages)
        case .requestTimeOut:
            return "Looks like the server is taking to long to respond \n this can be caused by either poor connectivity or an error with our servers.\n Please try again in a while"
        }
    }
}
