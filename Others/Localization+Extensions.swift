//
//  Localization+Extensions.swift
//  Hitrav
//
//  Created by Hamed Pouramiri on 12/18/20.
//  Copyright © 2020 Pixel. All rights reserved.
//

import Foundation
import UIKit

extension CGFloat {
    func roundTo(places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (Double(self) * divisor).rounded() / divisor
    }
}

extension Float {
    func roundTo(places: Int) -> Float {
        let divisor = pow(10.0, Double(places))
        return Float((Double(self) * divisor).rounded() / divisor)
    }
}

extension String {
    func toDouble(places: Int = 2) -> Double {
        let doubleSelf = Double(self) ?? 0.0
        let divisor = pow(10.0, Double(places))
        return (doubleSelf * divisor).rounded() / divisor
    }
    func toInt() -> Int {
        Int(self) ?? 0
    }
}

extension Int {
    func toLocalizedFormat(usesGroupingSeparator: Bool = false, numberStyle: NumberFormatter.Style = .none) -> String {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = usesGroupingSeparator
        formatter.numberStyle = numberStyle
        formatter.locale = LanguageManager.shared.locale
        return formatter.string(from: NSNumber(value: self))!
    }
}

extension Double {
    func toLocalizedFormat(usesGroupingSeparator: Bool = true, numberStyle: NumberFormatter.Style = .decimal) -> String {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = usesGroupingSeparator
        formatter.numberStyle = numberStyle
        formatter.locale = LanguageManager.shared.locale
        return formatter.string(from: NSNumber(value: self))!
    }

    func toInt() -> Int {
        Int(self)
    }
}
