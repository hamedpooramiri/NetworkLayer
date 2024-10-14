//
//  UIDevice+Extension.swift
//  Hitrav
//
//  Created by Hamed Pouramiri on 11/20/20.
//  Copyright © 2020 Pixel. All rights reserved.
//

import UIKit

extension UIDevice {
   static var hasNotch: Bool {
        if #available(iOS 11.0, *) {
           return UIApplication.shared.sceneKeyWindow?.safeAreaInsets.bottom ?? 0 > 0
        }
        return false
   }

    static var bottomNotchHeight: CGFloat {
        if #available(iOS 11.0, *) {
            return UIApplication.shared.sceneKeyWindow?.safeAreaInsets.bottom ?? 0.0
        }
        return 0.0
    }

}

extension UIApplication {
    var sceneKeyWindow: UIWindow? {
        UIApplication.shared.windows.first { $0.isKeyWindow }
    }
}
