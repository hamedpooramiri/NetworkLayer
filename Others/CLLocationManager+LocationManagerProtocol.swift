//
//  CLLocationManager+LocationManagerProtocol.swift
//  Hitrav
//
//  Created by Hamed Pouramiri on 1/14/21.
//  Copyright © 2021 Pixel. All rights reserved.
//

import CoreLocation
import Foundation

protocol LocationManagerProtocol {
    var locationManagerDelegate: CLLocationManagerDelegate? { get set }
    var desiredAccuracy: CLLocationAccuracy { get set }
    func requestLocation()
    func startUpdatingLocation()
    func requestWhenInUseAuthorization()
    func stopUpdatingLocation()
}

extension CLLocationManager: LocationManagerProtocol {
    var locationManagerDelegate: CLLocationManagerDelegate? {
        get { return delegate }
        set { delegate = newValue }
    }
}
