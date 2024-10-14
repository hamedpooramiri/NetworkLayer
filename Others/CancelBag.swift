//
//  CancelBag.swift
//  Hitrav
//
//  Created by Hamed Pouramiri on 6/24/21.
//  Copyright © 2021 Pixel. All rights reserved.
//

import Combine

final class CancelBag {
    fileprivate(set) var subscriptions = Set<AnyCancellable>()

    func cancel() {
        subscriptions.removeAll()
    }
}

extension AnyCancellable {

    func store(in cancelBag: CancelBag) {
        cancelBag.subscriptions.insert(self)
    }
}
