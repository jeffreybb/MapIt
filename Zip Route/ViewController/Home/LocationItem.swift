//
//  LocationItem.swift
//  Zip Route
//
//  Created by Jeff on 11/21/19.
//  Copyright © 2019 OverSphere LLC. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

struct LocationItem {
	let mapItem: MKMapItem
	
}

extension LocationItem {
	var name: String? {
		return mapItem.name
	}
	
	var streetNumber: String {
		return mapItem.placemark.subThoroughfare ?? ""
	}
	
	var streetName: String {
		return mapItem.placemark.thoroughfare ?? ""
	}
	
	var cityName: String {
		return mapItem.placemark.locality ?? ""
	}
	
	var streetAddress: String {
		return "\(streetNumber) \(streetName)"
	}
	
	func distanceFrom(currentLocation: CLLocation) -> Double? {
		guard let location = mapItem.placemark.location else { return nil }
		
		return location.distance(from: currentLocation)
	}
}
