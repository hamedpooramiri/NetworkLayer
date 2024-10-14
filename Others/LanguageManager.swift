//
//  LanguageManager.swift
//  Hitrav
//
//  Created by Hamed Pouramiri on 10/13/20.
//  Copyright © 2020 Pixel. All rights reserved.
//

import SwiftUI
import UIKit

class LanguageManager {

    static var shared: LanguageManager = LanguageManager()

    private lazy var defaultLanguage: Language = SupportedLanguage.turkish.info

    var preferredLanguages: [String] = [
        UserDefaults.language ?? SupportedLanguage.turkish.info.abbrivation,
        SupportedLanguage.english.rawValue
    ]

    var currentLanguage: SupportedLanguage {
        SupportedLanguage(rawValue: UserDefaults.language ?? defaultLanguage.abbrivation) ?? .english
    }

    let languages: [Language] = SupportedLanguage.allCases.map { $0.info }

    var locale: Locale {
        SupportedLanguage(rawValue: preferredLanguages.first ?? "tr")?.info.locale ?? Locale(identifier: "tr")
    }

    // MARK: functions

    func setLanguage(_ language: SupportedLanguage) {
        UserDefaults.language = language.rawValue
        preferredLanguages = [language.rawValue, SupportedLanguage.english.rawValue]
    }

    enum SupportedLanguage: String, CaseIterable {
         case english = "en"
         case turkish = "tr"
         case russian = "ru"
         case persian = "fa"
         case arabic = "ar"
        var info: Language {
            switch self {
            case .english:
                return  .init(id: 1, name: "English", subHeading: "English", abbrivation: "en", locale: .init(identifier: "en_US_POSIX"))
            case .turkish:
                return .init(id: 2, name: "Turkish", subHeading: "Türkce", abbrivation: "tr", locale: .init(identifier: "tr"))
            case .russian:
                return .init(id: 3, name: "Russian", subHeading: "русский", abbrivation: "ru", locale: .init(identifier: "ru"))
            case .persian:
                return .init(id: 4, name: "Persian", subHeading: "فارسی", abbrivation: "fa", locale: .init(identifier: "fa"))
            case .arabic:
                return .init(id: 5, name: "Arabic", subHeading: "العربیه", abbrivation: "ar", locale: .init(identifier: "ar"))
            }
        }
     }

    class Language: NSObject, Searchable, shareable {
        var id: Int
        var name: String?
        var subHeading: String
        let abbrivation: String
        let locale: Locale
        init(id: Int, name: String, subHeading: String, abbrivation: String, locale: Locale) {
            self.name = name
            self.subHeading = subHeading
            self.id = id
            self.abbrivation = abbrivation
            self.locale = locale
        }
    }

}
// MARK: LanguageManager Extension on View
extension View {
    public var preferredLanguages: [String] {
        LanguageManager.shared.preferredLanguages
    }
}
// MARK: LanguageManager Extension on UIView
extension UIView {
    public var preferredLanguages: [String] {
        LanguageManager.shared.preferredLanguages
    }
}
// MARK: LanguageManager Extension on UIViewController
extension UIViewController {
    public var preferredLanguages: [String] {
        LanguageManager.shared.preferredLanguages
    }
}
