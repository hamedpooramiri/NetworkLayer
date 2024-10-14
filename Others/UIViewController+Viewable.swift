//
//  UIViewController+Viewable.swift
//  Hitrav
//
//  Created by Hamed Pouramiri on 8/10/20.
//  Copyright © 2020 Pixel. All rights reserved.
//

import Foundation
import UIKit

protocol Viewable: AnyObject {
    func push(_ view: UIViewController, animated: Bool)
    func present(_ view: UIViewController, animated: Bool)
    func pop(animated: Bool)
    func dismiss(animated: Bool)
    func dismiss(animated: Bool, _ completion:  @escaping (() -> Void))
    func popToRoot(animated: Bool)
    func presentInFullScreen(_ view: UIViewController, animated: Bool, completion: (() -> Void)?)
}

extension  UIViewController: Viewable {

    func push(_ view: UIViewController, animated: Bool = true ) {
        self.navigationController?.pushViewController(view, animated: animated)
    }

    func present(_ view: UIViewController, animated: Bool = true) {
        self.present(view, animated: animated, completion: nil)
    }

    func presentInFullScreen(_ view: UIViewController, animated: Bool, completion: (() -> Void)? = nil) {
        view.modalPresentationStyle = .fullScreen
        present(view, animated: animated, completion: completion)
    }

    func pop(animated: Bool) {
        self.navigationController?.popViewController(animated: animated)
    }

    func popToRoot(animated: Bool = true) {
        self.navigationController?.popToRootViewController(animated: animated)
    }

    func dismiss(animated: Bool) {
        self.dismiss(animated: animated, completion: nil)
    }

    func dismiss(animated: Bool, _ completion: @escaping (() -> Void)) {
        self.dismiss(animated: animated, completion: completion)
    }

}
