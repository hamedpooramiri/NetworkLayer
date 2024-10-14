//
//  QRGenerator.swift
//  Connect
//
//  Created by Hamed Pouramiri on 6/13/20.
//  Copyright © 2020 Hamed Pouramiri. All rights reserved.
//
//swiftlint:disable force_unwrapping

import Combine
import CoreGraphics
import CoreImage
import Foundation
import UIKit

extension UIImage {
    class func generateQRImage(for stringQR: String, withSizeRate rate: CGFloat) -> UIImage {

        // select the specific filter for image
        let  filter: CIFilter = CIFilter(name: "CIQRCodeGenerator")!
        filter.setDefaults()

        // convert string to data and set it to the filter
        let data: Data = stringQR.data(using: .utf8)!
        filter.setValue(data, forKey: "inputMessage")

        // get the outPut image
        let outputImg: CIImage = filter.outputImage!

        // using CIContext to generate the coreGraphic image
        let context: CIContext = CIContext(options: nil)
        let cgimg: CGImage = context.createCGImage(outputImg, from: outputImg.extent)!

        // convert to uiImage
        var img: UIImage = UIImage(cgImage: cgimg, scale: 1.0, orientation: .up)

        // set the ratio
        let width = img.size.width * rate
        let height = img.size.height * rate

        UIGraphicsBeginImageContext(CGSize(width: width, height: height))
        let cgContxt: CGContext = UIGraphicsGetCurrentContext()!
        cgContxt.interpolationQuality = .none // set the insertion quality

        img.draw(in: CGRect(x: 0, y: 0, width: width, height: height))

        img = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return img
    }
}
