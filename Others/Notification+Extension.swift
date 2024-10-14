//
//  Notification+Extension.swift
//  Hitrav
//
//  Created by Hamed Pouramiri on 11/2/20.
//  Copyright © 2020 Pixel. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let splashing = Notification.Name("splashing")
    static let continueLunching = Notification.Name("splashing")

    func post(center: NotificationCenter = NotificationCenter.default, object: Any? = nil, userInfo: [AnyHashable: Any]? = nil) {
        center.post(name: self, object: object, userInfo: userInfo)
    }

    @discardableResult
    func onPost(center: NotificationCenter = NotificationCenter.default, object: Any? = nil, queue: OperationQueue? = nil, using: @escaping (Notification) -> Void) -> NSObjectProtocol {
        center.addObserver(forName: self, object: object, queue: queue, using: using)
    }
}
