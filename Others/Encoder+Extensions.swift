//
//  Encoder+Extensions.swift
//  Hitrav
//
//  Created by Amir on 8/2/20.
//  Copyright © 2020 Pixel. All rights reserved.
//

import Foundation

extension Encodable {
    public func toString() -> String? {
        let jsonEncoder = JSONEncoder()
        do {
            let jsonEncoded = try jsonEncoder.encode(self)
            let json = String(data: jsonEncoded, encoding: .utf8)
            return json
        } catch {
            return nil
        }
    }

    public func toData() -> Data? {
        let jsonEncoder = JSONEncoder()
        do {
            let jsonEncoded = try jsonEncoder.encode(self)
            return jsonEncoded
        } catch {
            return nil
        }
    }
}
