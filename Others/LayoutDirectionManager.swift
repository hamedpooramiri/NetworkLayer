//
//  LayoutDirectionManager.swift
//  Hitrav
//
//  Created by Hamed Pouramiri on 12/12/20.
//  Copyright © 2020 Pixel. All rights reserved.
//

import Foundation
import SwiftUI

class LayoutDirectionManager {

    // for SwiftUI views usage
    class var layoutDirection: LayoutDirection {
        switch LanguageManager.shared.currentLanguage {
        case .turkish, .english, .russian:
            return .leftToRight
        default:
            return .rightToLeft
        }
    }
    // for UIKit views usage
    class var semanticContentAttribute: UISemanticContentAttribute {
        layoutDirection == .leftToRight ? .forceLeftToRight : .forceRightToLeft
    }

    class var textAlignment: NSTextAlignment {
        layoutDirection == .leftToRight ? .left : .right
    }

    class var switchToRTL: Bool {
        layoutDirection == .rightToLeft
    }

    class func configure() {
        UIView.appearance().semanticContentAttribute = semanticContentAttribute
        UINavigationBar.appearance().semanticContentAttribute = semanticContentAttribute
        UITabBar.appearance().semanticContentAttribute = .forceLeftToRight
        UIView.appearance(whenContainedInInstancesOf: [UIToolbar.self]).semanticContentAttribute = .forceLeftToRight
    }
}
