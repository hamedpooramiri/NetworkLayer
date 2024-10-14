//
//  Binding+Extensions.swift
//  Hitrav
//
//  Created by Hamed Pouramiri on 5/21/21.
//  Copyright © 2021 Pixel. All rights reserved.
//

import SwiftUI

extension Binding {
    func onChange(_ handler: @escaping (Value) -> Void) -> Binding<Value> {
        Binding(
            get: { self.wrappedValue },
            set: { newValue in
                self.wrappedValue = newValue
                handler(newValue)
            }
        )
    }
}
