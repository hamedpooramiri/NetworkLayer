//
//  Bundle+Extension.swift
//  Hitrav
//
//  Created by Hamed Pouramiri on 10/18/20.
//  Copyright © 2020 Pixel. All rights reserved.
//

import Foundation

extension Bundle {
    var appVersion: String? {
         infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
         infoDictionary?["CFBundleVersion"] as? String
    }
}
