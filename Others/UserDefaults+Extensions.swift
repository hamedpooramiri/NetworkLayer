//
//  UserDefaults+Extensions.swift
//  Hitrav
//
//  Created by Amir on 8/14/20.
//  Copyright © 2020 Pixel. All rights reserved.
//

import Foundation

private struct UserDefaultKeys {
    static let accessTokenKey = "accessToken"
    static let refreshTokenKey = "refreshToken"
    static let languageKey = "language"
    static let badge = "badge"
}

extension UserDefaults {
    public static var accessToken: String? {
        get {
            UserDefaults.standard.string(forKey: UserDefaultKeys.accessTokenKey)
        }

        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultKeys.accessTokenKey)
        }
    }

    public static var refreshToken: String? {
        get {
            UserDefaults.standard.string(forKey: UserDefaultKeys.refreshTokenKey)
        }

        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultKeys.refreshTokenKey)
        }
    }

    public static var language: String? {
        get {
            UserDefaults.standard.string(forKey: UserDefaultKeys.languageKey)
        }

        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultKeys.languageKey)
        }
    }

    class func logoutUser() {
        standard.removeObject(forKey: UserDefaultKeys.accessTokenKey)
        standard.removeObject(forKey: UserDefaultKeys.refreshTokenKey)
    }
}
// user: 9363470508   pass: 962098145

extension UserDefaults {
    static let suiteName = "group.com.pixel.ios.Hitrav.PushNotifications"
    static let extensions = UserDefaults(suiteName: suiteName)!

    var badge: Int {
        get {
            UserDefaults.extensions.integer(forKey: UserDefaultKeys.badge)
        }
        set {
            UserDefaults.extensions.set(newValue, forKey: UserDefaultKeys.badge)
        }
    }

}
