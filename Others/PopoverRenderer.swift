//
//  PopoverRenderer.swift
//  Hitrav
//
//  Created by Hamed Pouramiri on 9/24/20.
//  Copyright © 2020 Pixel. All rights reserved.
//

import SwiftMessages
import SwiftUI
import UIKit

struct PopoverRenderer {
    // TODO: implement RTL for Future
    private static var loadingView = UIBlockerActivityIndicatorView(message: Localizable.please_wait(preferredLanguages: LanguageManager.shared.preferredLanguages))

    static func presentError(title: String? = nil, body: String, presentationStyle: SwiftMessages.PresentationStyle = .top, presentationContext: SwiftMessages.PresentationContext = .automatic, autoHiding: Bool = true, dimMode: SwiftMessages.DimMode = .none, interactiveHide: Bool = true ) {
        let view = MessageView.viewFromNib(layout: .cardView)
        view.configureTheme(.error)
        view.configureDropShadow()
        view.button?.isHidden = true
        [view.titleLabel, view.bodyLabel].forEach { lbl in
            lbl?.font = .normalText
            lbl?.textColor = .red
        }
//        view.configureContent(title: title ?? "", body: body, iconImage: UIImage())
        view.configureContent(title: title, body: body, iconImage: nil, iconText: nil, buttonImage: nil, buttonTitle: nil, buttonTapHandler: nil)
        view.backgroundView.backgroundColor = R.color.mistyRose()

        view.layoutMarginAdditions = UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 20)
        //        (view.backgroundView as? CornerRoundingView)?.cornerRadius = 10

        var config = SwiftMessages.Config()
        config.presentationStyle = presentationStyle
        config.presentationContext = presentationContext
        config.duration = autoHiding ? .automatic : .forever
        config.dimMode = dimMode
        config.interactiveHide = interactiveHide
        SwiftMessages.show(config: config, view: view)
    }

  static func presentReloadViewError(title: String?, body: String, reloadButtonTitle: String, presentationStyle: SwiftMessages.PresentationStyle = .top, presentationContext: SwiftMessages.PresentationContext = .automatic, autoHiding: Bool = false, dimMode: SwiftMessages.DimMode = .none, interactiveHide: Bool = true, buttonTapHandler: @escaping (UIButton, SwiftMessages) -> Void) {
        let view = MessageView.viewFromNib(layout: .cardView)
        view.configureTheme(.error)
        view.configureDropShadow()
        view.button?.setTitle(reloadButtonTitle, for: .normal)
        view.button?.titleLabel?.font = .normalText
        view.configureContent(title: title, body: body, iconImage: nil, iconText: nil, buttonImage: nil, buttonTitle: reloadButtonTitle) { btn in
            buttonTapHandler(btn, SwiftMessages.sharedInstance)
        }
        view.configureContent(title: title ?? "", body: body)
//        (view.backgroundView as? CornerRoundingView)?.cornerRadius = 10
        var config = SwiftMessages.Config()
        config.presentationStyle = presentationStyle
        config.presentationContext = presentationContext
        config.duration = autoHiding ? .automatic : .forever
        config.dimMode = dimMode
        config.interactiveHide = interactiveHide
        SwiftMessages.show(config: config, view: view)
    }

    static func presentWarningView(title: String?, body: String, reloadButtonTitle: String, presentationStyle: SwiftMessages.PresentationStyle = .top, presentationContext: SwiftMessages.PresentationContext = .automatic, autoHiding: Bool = false, dimMode: SwiftMessages.DimMode = .none, interactiveHide: Bool = true, buttonTapHandler: @escaping (UIButton, SwiftMessages) -> Void) {
          let view = MessageView.viewFromNib(layout: .cardView)
          view.configureTheme(.warning)
          view.configureDropShadow()
          view.button?.setTitle(reloadButtonTitle, for: .normal)
          view.button?.titleLabel?.font = .normalText
         let image = R.image.warning()?.withRenderingMode(.alwaysTemplate)
//        image?.withTintColor(<#T##color: UIColor##UIColor#>)
        view.configureContent(title: title, body: body, iconImage: image, iconText: nil, buttonImage: nil, buttonTitle: reloadButtonTitle) { btn in
              buttonTapHandler(btn, SwiftMessages.sharedInstance)
          }
          view.configureContent(title: title ?? "", body: body)
          var config = SwiftMessages.Config()
          config.presentationStyle = presentationStyle
          config.presentationContext = presentationContext
          config.duration = autoHiding ? .automatic : .forever
          config.dimMode = dimMode
          config.interactiveHide = interactiveHide
          SwiftMessages.show(config: config, view: view)
      }

    static func presentSucceedView(title: String? = nil, body: String, presentationStyle: SwiftMessages.PresentationStyle = .top, presentationContext: SwiftMessages.PresentationContext = .automatic, autoHiding: Bool = true, dimMode: SwiftMessages.DimMode = .none, interactiveHide: Bool = true ) {
        let view = MessageView.viewFromNib(layout: .cardView)
        view.configureTheme(.success)
        view.configureDropShadow()
        view.button?.isHidden = true
        [view.titleLabel, view.bodyLabel].forEach { lbl in
            lbl?.textColor = R.color.mediumSeaGreen()
        }
        view.bodyLabel?.font = .normalText
//        view.configureContent(title: title ?? "", body: body, iconImage: UIImage())
        view.configureContent(title: title, body: body, iconImage: nil, iconText: nil, buttonImage: nil, buttonTitle: nil, buttonTapHandler: nil)
        view.backgroundView.backgroundColor = R.color.cosmicLatte()

        view.layoutMarginAdditions = UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 20)
        //        (view.backgroundView as? CornerRoundingView)?.cornerRadius = 10

        var config = SwiftMessages.Config()
        config.presentationStyle = presentationStyle
        config.presentationContext = presentationContext
        config.duration = autoHiding ? .automatic : .forever
        config.dimMode = dimMode
        config.interactiveHide = interactiveHide
        SwiftMessages.show(config: config, view: view)
    }

    static func presentPlaceSucceedView(title: String? = nil, body: String, presentationStyle: SwiftMessages.PresentationStyle = .top, presentationContext: SwiftMessages.PresentationContext = .automatic, autoHiding: Bool = true, dimMode: SwiftMessages.DimMode = .none, interactiveHide: Bool = true ) {
        let view = MessageView.viewFromNib(layout: .cardView)
        view.configureTheme(.success)
        view.configureDropShadow()
        view.button?.isHidden = true
        [view.titleLabel, view.bodyLabel].forEach { lbl in
            lbl?.textColor = R.color.htWhite()
        }
        view.bodyLabel?.font = .normalText
//        view.configureContent(title: title ?? "", body: body, iconImage: UIImage())
        view.configureContent(title: title, body: body, iconImage: nil, iconText: nil, buttonImage: nil, buttonTitle: nil, buttonTapHandler: nil)
        view.backgroundView.backgroundColor = R.color.htSanteFe()

        view.layoutMarginAdditions = UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 20)
        //        (view.backgroundView as? CornerRoundingView)?.cornerRadius = 10

        var config = SwiftMessages.Config()
        config.presentationStyle = presentationStyle
        config.presentationContext = presentationContext
        config.duration = autoHiding ? .automatic : .forever
        config.dimMode = dimMode
        config.interactiveHide = interactiveHide
        SwiftMessages.show(config: config, view: view)
    }

    static func presentLoadingView(_ state: Bool, message: String? = nil) {
        loadingView
            .setMessage(message ?? Localizable.please_wait(preferredLanguages: LanguageManager.shared.preferredLanguages))
        if state {
            loadingView.show()
        } else {
            loadingView.hide()
        }
    }

    static func presentNoConnectionErrorView(presenter: ErrorHandlerPresenterProtocol, error: Error) {
        NoConnectionErrorView(presenter: presenter, error: error).show()
    }

    static func presentServerSideErrorView(presenter: ErrorHandlerPresenterProtocol, error: Error) {
        ServerSideErrorView(presenter: presenter, error: error).show()
    }

    static func presentServiceUnavailableErrorView(presenter: ErrorHandlerPresenterProtocol, error: Error) {
        ServiceUnavailableErrorView(presenter: presenter, error: error).show()
    }

    static func presentReportErrorView() {
        // TODO: must complete later
    }
}
