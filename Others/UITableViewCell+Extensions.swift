//
//  UITableViewCell+Extensions.swift
//  Hitrav
//
//  Created by Hamed Pouramiri on 6/12/21.
//  Copyright © 2021 Pixel. All rights reserved.
//

import UIKit

extension UITableViewCell {
    static var reuseIdentifier: String { String(describing: self) }
}

extension UITableViewHeaderFooterView {
    static var reuseIdentifier: String { String(describing: self) }
}

extension UITableView {
    @discardableResult
    func register<T: UITableViewCell>(_ type: T.Type) -> Self {
        register(type, forCellReuseIdentifier: type.reuseIdentifier)
        return self
    }

    func dequeueReusableCell<T: UITableViewCell>(_ type: T.Type) -> T? {
        dequeueReusableCell(withIdentifier: type.reuseIdentifier) as? T
    }
}
