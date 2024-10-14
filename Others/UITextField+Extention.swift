//
//  UITextField+Extention.swift
//  Hitrav
//
//  Created by Hamed Pouramiri on 8/6/20.
//  Copyright © 2020 Pixel. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {

    @IBInspectable var doneAccessory: Bool {
        get { self.doneAccessory }
        set {
            if newValue {
                addDoneButtonOnKeyboard()
            }
        }
    }

    private  func addDoneButtonOnKeyboard() {

        var doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default

        if (inputAccessoryView != nil), let toolbar = inputAccessoryView as? UIToolbar {
            doneToolbar = toolbar
        }

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        let items = [flexSpace, done]

        if var doneToolbarTtems = doneToolbar.items {
            doneToolbarTtems.append(contentsOf: items)
        } else {
            doneToolbar.items = items
        }

        doneToolbar.sizeToFit()
        self.inputAccessoryView = doneToolbar
    }

    @objc
    private func doneButtonAction() {
        self.resignFirstResponder()
    }
}
