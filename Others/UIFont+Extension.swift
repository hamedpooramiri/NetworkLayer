//
//  UIFont+Extension.swift
//  Hitrav
//
//  Created by Hamed Pouramiri on 12/24/20.
//  Copyright © 2020 Pixel. All rights reserved.
//
//swiftlint:disable force_unwrapping

import Foundation
import UIKit

extension UIFont {

    private class var currentLanguage: LanguageManager.SupportedLanguage {
        LanguageManager.shared.currentLanguage
    }

    class var yachtTitle: UIFont {
        currentLanguage == .persian ? R.font.iranYekanMobileFNBold(size: 28)! : R.font.sfProTextBold(size: 28)!
    }
    class var sectionTitle: UIFont {
        currentLanguage == .persian ? R.font.iranYekanMobileFNBold(size: 24)! : R.font.sfProTextBold(size: 24)!
    }
    class var heading: UIFont {
        currentLanguage == .persian ? R.font.iranYekanMobileFNBold(size: 18)! : R.font.sfProTextMedium(size: 18.0)!
    }
    class var boldHeading: UIFont {
        currentLanguage == .persian ? R.font.iranYekanMobileFNBold(size: 16)! : R.font.sfProTextBold(size: 16)!
    }
    class var regularHeading: UIFont {
        currentLanguage == .persian ? R.font.iranYekanMobileFN(size: 16)! : R.font.sfProTextRegular(size: 16)!
    }
    class var boldText: UIFont {
        currentLanguage == .persian ? R.font.iranYekanMobileFNBold(size: 14)! : R.font.sfProTextSemibold(size: 14.0)!
    }
    class var normalText: UIFont {
        currentLanguage == .persian ? R.font.iranYekanMobileFN(size: 14)! : R.font.sfProTextRegular(size: 14.0)!
    }
    class var lightText: UIFont {
        currentLanguage == .persian ? R.font.iranYekanMobileLight(size: 14)! : R.font.sfProTextLight(size: 14.0)!
    }
    class var boldType: UIFont {
        currentLanguage == .persian ? R.font.iranYekanMobileFNBold(size: 12)! : R.font.sfProTextSemibold(size: 12.0)!
    }
    class var lightType: UIFont {
        currentLanguage == .persian ? R.font.iranYekanMobileLight(size: 12)! : R.font.sfProTextLight(size: 12.0)!
    }
    class var smallType: UIFont {
        currentLanguage == .persian ? R.font.iranYekanMobileFNMedium(size: 10.0)! : R.font.sfProTextMedium(size: 10.0)!
    }
    class var type: UIFont {
        currentLanguage == .persian ? R.font.iranYekanMobileLight(size: 10.0)! : R.font.sfProTextLight(size: 10.0)!
    }
    class var boldCaption: UIFont {
        currentLanguage == .persian ? R.font.iranYekanMobileFNMedium(size: 8.0)! : R.font.sfProTextMedium(size: 8.0)!
    }
    class var lightCaption: UIFont {
        currentLanguage == .persian ? R.font.iranYekanMobileLight(size: 8.0)! : R.font.sfProTextLight(size: 8.0)!
    }
}
