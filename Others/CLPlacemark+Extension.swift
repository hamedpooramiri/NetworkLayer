//
//  CLPlacemark+Extension.swift
//  Hitrav
//
//  Created by Hamed Pouramiri on 1/16/21.
//  Copyright © 2021 Pixel. All rights reserved.
//

import CoreLocation
import MapKit

extension CLPlacemark {
    var compactAddress: String? {
        if let name = name {
            var result = name

            if let street = thoroughfare {
                result += ", \(street)"
            }

            if let city = locality {
                result += ", \(city)"
            }

            if let country = country {
                result += ", \(country)"
            }

            return result
        }
        return nil
    }
}

class Placemark: NSObject, shareable, Searchable {

    var id: Int
    var name: String?
    var location: CLLocation?
    var compactAddress: String?

    init(clPlacemark: CLPlacemark) {
        self.id = clPlacemark.location?.coordinate.latitude.exponent ?? 0
        self.name = clPlacemark.name
        self.location = clPlacemark.location
        self.compactAddress = clPlacemark.compactAddress
    }

    init(annotation: MKPointAnnotation) {
        self.id = annotation.hash
        self.name = annotation.title
        self.location = .init(latitude: annotation.coordinate.latitude,
                              longitude: annotation.coordinate.longitude)
        self.compactAddress = (annotation.title ?? "") + (annotation.subtitle ?? "")
    }

}
