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
	func locationService(_ service: LocationService, didUpdateCurrentLocation location: CLLocation)
}

final class LocationService: NSObject {
	
	private let locationManager = CLLocationManager()
	private unowned let delegate: LocationServiceDelegate
	
	init(delegate: LocationServiceDelegate) {
		self.delegate = delegate
		super.init()
		locationManager.delegate = self
	}
	
	// MARK: Internal
	func requestAuthorization() {
		locationManager.requestAlwaysAuthorization()
	}
	
	func requestCurrentLocation() {
		locationManager.requestLocation()
	}
	
}

// MARK: - CLLocationManagerDelegate
extension LocationService: CLLocationManagerDelegate {
	
	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		print("LocationService didChangeAuthorization:")
		switch status {
			
		case .notDetermined:
			print("notDetermined")
		case .restricted:
			print("restricted")
		case .denied:
			print("denied")
		case .authorizedAlways:
			print("authorizedAlways")
			locationManager.requestLocation()
		case .authorizedWhenInUse:
			print("authorizedWhenInUse")
			locationManager.requestLocation()
		@unknown default:
			break
		}
	}
	
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		delegate.locationService(self, didFailWithError: error)
	}
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		if let currentLocation = locations.last {
			delegate.locationService(self, didUpdateCurrentLocation: currentLocation)
		}
	}
	
}
