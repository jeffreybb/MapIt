//
//  MKAnnotation+CLLocation.swift
//  Zip Route
//
//  Created by Jeff on 11/21/19.
//  Copyright © 2019 OverSphere LLC. All rights reserved.
//

import MapKit

extension MKAnnotation {
	var location: CLLocation {
		return CLLocation(latitude: self.coordinate.latitude, longitude: self.coordinate.longitude)
	}
}
