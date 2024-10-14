//
//  UIViewController+StoryboardLoading.swift
//  Hitrav
//
//  Created by Hamed Pouramiri on 6/13/21.
//  Copyright © 2021 Pixel. All rights reserved.
//

import UIKit

protocol UIViewControllerLoading {}

/// Extend UIViewController to declare that it includes storyboard loading functionality
extension UIViewController: UIViewControllerLoading {}

/// Protocol implementation
extension UIViewControllerLoading where Self: UIViewController {

    static private var className: String {
        return String(describing: self)
    }

    static func loadFromStoryboard(storyboardName: String? = nil) -> Self {
        let nibName = storyboardName ?? className
        let storyboard = UIStoryboard(name: nibName, bundle: nil)

        guard let view = storyboard.instantiateViewController(identifier: className) as? Self else {
            fatalError("Could not instantiate initial storyboard with name: \(className)")
        }

        return view
    }

}
