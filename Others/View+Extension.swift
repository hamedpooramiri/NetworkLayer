//
//  View+Extension.swift
//  Hitrav
//
//  Created by Hamed Pouramiri on 8/21/20.
//  Copyright © 2020 Pixel. All rights reserved.
//
import Combine
import SwiftUI

extension View {
    var screenWidth: CGFloat { UIScreen.main.bounds.width }
    var screenHeight: CGFloat { UIScreen.main.bounds.height }

    // MARK: Embed swiftUI view to ViewControler
    func addTo(viewController: UIViewController) -> UIView {
        let swiftUIController = UIHostingController(rootView: self)
        viewController.addChild(swiftUIController)
        swiftUIController.didMove(toParent: viewController)
        return swiftUIController.view
    }
}

// MARK: ErrorHandler

extension View {
    func receiveError(_ error: PassthroughSubject<Error, Never>, presenter: ErrorHandlerPresenterProtocol) -> some View {
        self.onReceive(error) { ErrorHandler.handle($0, presenter: presenter) }
    }
}

extension UIViewController {
    func receiveError(_ error: PassthroughSubject<Error, Never>, presenter: ErrorHandlerPresenterProtocol) -> AnyCancellable {
        error.sink { ErrorHandler.handle($0, presenter: presenter) }
    }
}

extension View {
    @ViewBuilder func hidden(_ shouldHide: Bool) -> some View {
        if shouldHide { hidden() }
        else { self }
    }
}

extension Animation {
    func `repeat`(while expression: Bool, autoreverses: Bool = true) -> Animation {
        if expression {
            return self.repeatForever(autoreverses: autoreverses)
        } else {
            return self
        }
    }
}

extension View {
    var ios14: Bool {
        if #available(iOS 14.0, *) {
            return true
        } else {
            return false
        }
    }
}

extension View {
    func onAppear(asyncAfter deadline: DispatchTime, perform action: @escaping (() -> Void) ) -> some View {
       return onAppear(perform: {
            DispatchQueue.main.asyncAfter(deadline: deadline) {
                action()
            }
        })
    }
}
