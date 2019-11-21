//
//  LocationService.swift
//  Zip Route
//
//  Created by Jeff on 11/21/19.
//  Copyright © 2019 OverSphere LLC. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

protocol LocationServiceDelegate: class {
	func locationService(_ service: LocationService, didFailWithError error: Error)
}

final class LocationService: NSObject {
	
	private let locationManager = CLLocationManager()
	private unowned let delegate: LocationServiceDelegate
	
	init(delegate: LocationServiceDelegate) {
		self.delegate = delegate
		super.init()
		locationManager.delegate = self
	}
	
}

// MARK: - CLLocationManagerDelegate
extension LocationService: CLLocationManagerDelegate {
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		delegate.locationService(self, didFailWithError: error)
	}
}
