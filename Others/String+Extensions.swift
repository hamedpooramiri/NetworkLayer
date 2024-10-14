//
//  String+Extensions.swift
//  Hitrav
//
//  Created by Hamed Pouramiri on 8/5/20.
//  Copyright © 2020 Pixel. All rights reserved.
//

import Foundation

extension String {
    var isValidEmail: Bool {
        let regularExpressionForEmail = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let testEmail = NSPredicate(format: "SELF MATCHES %@", regularExpressionForEmail)
        return testEmail.evaluate(with: self)
    }
    var isValidPhone: Bool {
        let regularExpressionForPhone = "^\\d{3}-\\d{3}-\\d{4}$"
        let testPhone = NSPredicate(format: "SELF MATCHES %@", regularExpressionForPhone)
        return testPhone.evaluate(with: self)
    }
    var isAllDigits: Bool {
        let charcterSet = NSCharacterSet(charactersIn: "0123456789").inverted
        let inputString = self.components(separatedBy: charcterSet)
        let filtered = inputString.joined(separator: "")
        return  self == filtered
    }

    var isAlphbet: Bool {
        var error = 0
        forEach { char in
            if !char.isLetter {
                error += 1
            }
        }
        return error == 0 ? true : false
        // return !isEmpty && range(of: "[^a-zA-Z]", options: .regularExpression) == nil
    }

    var isEmptyOrWhitespace: Bool {
        // Check empty string
        if self.isEmpty {
            return true
        }
        // Trim and check empty string
        return (self.trimmingCharacters(in: .whitespaces) == "")
    }

    func toEstanbolDate(withFormat format: String = "yyyy-MM-dd'T'HH:mm:ssZ") -> Date? {

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = format

        let timeZoneOffset = TimeZone(abbreviation: "EEST")?.secondsFromGMT()
        guard let dateTime = dateFormatter.date(from: self) else { return nil }
        let epo = dateTime.timeIntervalSince1970
        let result = epo + Double(timeZoneOffset ?? 10800)
        return Date(timeIntervalSince1970: result)
    }

    func toDate(withFormat format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self)
    }

    var htmlToAttributedString: NSAttributedString? {
        if self == "" { return nil }
        let fontSizedString = "<div style=\"font-size:14px;text-align:justify;\">"+self+"</div>"
        do {
            guard let htmlData = NSString(string: fontSizedString).data(using: String.Encoding.unicode.rawValue) else {
                return nil
            }
            let options = [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html]
            let attributedString = try NSAttributedString(data: htmlData, options: options, documentAttributes: nil)
            return attributedString
        } catch {
            print("error: ", error)
            return nil
        }
    }
}

extension String {
    func stripOutHtml() -> String {
        replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
}
