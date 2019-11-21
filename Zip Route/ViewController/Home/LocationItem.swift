//
//  LocationItem.swift
//  Zip Route
//
//  Created by Jeff on 11/21/19.
//  Copyright © 2019 OverSphere LLC. All rights reserved.
//

import Foundation
import CoreLocation

struct LocationItem {
	let placemark: CLPlacemark
	
}

extension LocationItem {
	var streetName: String {
		return placemark.subThoroughfare ?? ""
	}
	
	var cityName: String {
		return placemark.subLocality ?? ""
	}
	
	var address: String {
		return "\(streetName), \(cityName)"
	}
	
	func getDistanceFromCurrentLocation(currentLocation: CLLocation) -> Double? {
		guard let location = placemark.location else { return nil }
		
		return placemark.location?.distance(from: currentLocation)
	}
}
