//
//  URL+Extensions.swift
//  Hitrav
//
//  Created by Hamed Pouramiri on 9/18/20.
//  Copyright © 2020 Pixel. All rights reserved.
//

import Foundation
import UIKit

extension URL {
    func valueOf(_ queryParamaterName: String) -> String? {
        guard let url = URLComponents(string: self.absoluteString) else { return nil }
        return url.queryItems?.first { $0.name == queryParamaterName }?.value?.removingPercentEncoding?.removingPercentEncoding
    }
}
