//
//  UICollectionViewCell+Extensions.swift
//  Hitrav
//
//  Created by Hamed Pouramiri on 6/12/21.
//  Copyright © 2021 Pixel. All rights reserved.
//

import UIKit

extension UICollectionReusableView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UICollectionView {
    @discardableResult
    func register<T: UICollectionViewCell>(_ type: T.Type) -> Self {
        register(type, forCellWithReuseIdentifier: type.reuseIdentifier)
        return self
    }

    func dequeueReusableCell<T: UICollectionViewCell>(_ type: T.Type, for indexPath: IndexPath) -> T? {
        dequeueReusableCell(withReuseIdentifier: type.reuseIdentifier, for: indexPath) as? T
    }

    @discardableResult
    func register<T: UICollectionReusableView>(_ type: T.Type, forSupplementaryViewOfKind kind: String) -> Self {
        register(type, forSupplementaryViewOfKind: kind, withReuseIdentifier: type.reuseIdentifier)
        return self
    }

}
