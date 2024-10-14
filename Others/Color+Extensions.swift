//
//  Color+Extensions.swift
//  Hitrav
//
//  Created by Amir on 7/30/20.
//  Copyright © 2020 Pixel. All rights reserved.
//

import SwiftUI
import UIKit

extension UIColor {
    var color: Color {
        Color(self)
    }
}

extension Color {

    var uiColor: UIColor {
        let components = self.components()
        return UIColor(red: components.red, green: components.green, blue: components.blue, alpha: components.alpha)
    }

    private func components() -> RGB {

        let scanner = Scanner(string: self.description.trimmingCharacters(in: CharacterSet.alphanumerics.inverted))
        var hexNumber: UInt64 = 0
        var red: CGFloat = 0.0, green: CGFloat = 0.0, blue: CGFloat = 0.0, alpha: CGFloat = 0.0

        let result = scanner.scanHexInt64(&hexNumber)
        if result {
            red = CGFloat((hexNumber & 0xff000000) >> 24) / 255
            green = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
            blue = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
            alpha = CGFloat(hexNumber & 0x000000ff) / 255
        }
        return RGB(red: red, green: green, blue: blue, alpha: alpha)
    }

    struct RGB {
        let red: CGFloat
        let green: CGFloat
        let blue: CGFloat
        let alpha: CGFloat
    }

}

extension UIFont {
    var font: Font {
        Font(self as CTFont)
    }
}
