//
//  Encodale+Extensions.swift
//  Hitrav
//
//  Created by Amir on 8/21/20.
//  Copyright © 2020 Pixel. All rights reserved.
//

import Foundation

extension Encodable {
    var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}
