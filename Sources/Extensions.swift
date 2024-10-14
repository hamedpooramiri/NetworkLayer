//
//  Extensions.swift
//
//  Original article:        http://danielemargutti.com/2017/09/09/network-layers-in-swift-updated/
//    Created by:                Daniele Margutti
//
//
//    Permission is hereby granted, free of charge, to any person obtaining a copy
//    of this software and associated documentation files (the "Software"), to deal
//    in the Software without restriction, including without limitation the rights
//    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//    copies of the Software, and to permit persons to whom the Software is
//    furnished to do so, subject to the following conditions:
//
//    The above copyright notice and this permission notice shall be included in
//    all copies or substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//    THE SOFTWARE.
import Foundation

// MARK: - Dictionary Extension
public extension Dictionary where Key == String, Value == Any? {
    /// Encode a dictionary as url encoded string
    ///
    /// - Parameter base: base url
    /// - Returns: encoded string
    /// - Throws: throw `.dataIsNotEncodable` if data cannot be encoded
    func urlEncodedString(base: String = "") throws -> String {
        guard self.count > 0 else { return "" } // nothing to encode

        var items: [URLQueryItem] = []

        self.forEach { (key, value) in
            guard let v = value else { return } // skip item if no value is set
            guard let arrayValue = value as? Array<String> else {
                items.append(URLQueryItem(name: key, value: String(describing: v)))
                return
            }
            items.append(contentsOf: arrayValue.map { URLQueryItem(name: "\(key)[]", value: "\($0)".trimmingCharacters(in: .whitespacesAndNewlines))})
        }

        var urlComponents = URLComponents(string: base)!
        urlComponents.queryItems = items
        guard let encodedString = urlComponents.url else {
            throw NetworkError.dataIsNotEncodable(self)
        }
        return encodedString.absoluteString
    }
    
}

public extension String {
    
    /// Fill up a string by replacing values in specified placeholders
    ///
    /// - Parameter dict: dict to use
    /// - Returns: replaced string
    func fill(withValues dict: [String: Any?]?) -> String {
        guard let data = dict else {
            return self
        }
        var finalString = self
        data.forEach { arg in
            if let unwrappedValue = arg.value {
                finalString = finalString.replacingOccurrences(of: "{\(arg.key)}", with: String(describing: unwrappedValue))
            }
        }
        return finalString
    }
    
    func stringByAdding(urlEncodedFields fields: ParametersDict?) throws -> String {
        guard let f = fields else { return self }
        return try f.urlEncodedString(base: self)
    }
    
}

extension URL {
    
    func appending(_ queryItem: String, value: String?) -> URL {
        
        guard var urlComponents = URLComponents(string: absoluteString) else { return absoluteURL }
        
        // Create array of existing query items
        var queryItems: [URLQueryItem] = urlComponents.queryItems ??  []
        
        // Create query item
        let queryItem = URLQueryItem(name: queryItem, value: value)
        
        // Append the new query item in the existing query items array
        queryItems.append(queryItem)
        
        // Append updated query items array in the url component object
        urlComponents.queryItems = queryItems
        
        // Returns the url from new url components
        return urlComponents.url!
    }
}
