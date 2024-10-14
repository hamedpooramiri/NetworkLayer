//
//  ViewInspection.swift
//  Hitrav
//
//  Created by Hamed Pouramiri on 6/24/21.
//  Copyright © 2021 Pixel. All rights reserved.
//
import Combine
import Foundation

internal final class Inspection<V> {
    let notice = PassthroughSubject<UInt, Never>()
    var callbacks = [UInt: (V) -> Void]()

    func visit(_ view: V, _ line: UInt) {
        if let callback = callbacks.removeValue(forKey: line) {
            callback(view)
        }
    }
}

extension ProcessInfo {
    var isRunningTests: Bool {
        environment["XCTestConfigurationFilePath"] != nil
    }
}
