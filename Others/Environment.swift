//
//  Environment.swift
//  Hitrav
//
//  Created by Hamed Pouramiri on 12/7/20.
//  Copyright © 2020 Pixel. All rights reserved.
//
//swiftlint:disable force_unwrapping
import Foundation

let environment: Environment = EnvironmentDecoder.decode()!

// add your Environment vars here 
struct Environment: Decodable {

    let baseURL: String
    let webCredentialDomain: String
    let firebaseClientID: String
    let staticImages: StaticImage
    let googleMapApiKey: String
    let googleMapUrl: String

    enum CodingKeys: String, CodingKey {
        case webCredentialDomain = "Web_Credential_Domain"
        case firebaseClientID = "Firebase_ClientID"
        case baseURL = "BASE_URL"
        case staticImages = "Static_Images"
        case googleMapApiKey = "GoogleMap_ApiKey"
        case googleMapUrl = "GoogleMap_URL"
    }

    struct StaticImage: Decodable {

        let baseURL: URL
        let car: URL
        let yacht: URL
        let food: URL
        let drink: URL

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let stringBaseUrl = try container.decode(String.self, forKey: .baseURL)
            let stringCarUrl = try container.decode(String.self, forKey: .car)
            let stringYachtUrl = try container.decode(String.self, forKey: .yacht)
            let stringFoodUrl = try container.decode(String.self, forKey: .food)
            let stringDrinkUrl = try container.decode(String.self, forKey: .drink)

            baseURL = URL(string: stringBaseUrl)!
            car = URL(string: stringCarUrl)!
            yacht = URL(string: stringYachtUrl)!
            food = URL(string: stringFoodUrl)!
            drink = URL(string: stringDrinkUrl)!
        }

        enum CodingKeys: String, CodingKey {
            case car = "CAR_URL"
            case yacht = "YACHT_URL"
            case baseURL = "BASE_URL"
            case food = "FOOD_URL"
            case drink = "DRINK_URL"
        }
    }
}

struct EnvironmentHolder: Decodable {

    let environment: Environment

    enum CodingKeys: String, CodingKey {
        case environment = "Environment"
    }
}

final class EnvironmentDecoder {
    static func decode() -> Environment? {
        let url = Bundle.main.url(forResource: "Info", withExtension: "plist")!
        let decoder = PropertyListDecoder()
        do {
            let data = try Data(contentsOf: url)
            let environmentHolder = try decoder.decode(EnvironmentHolder.self, from: data)
            return environmentHolder.environment
        } catch {
            return nil
        }
    }
}
