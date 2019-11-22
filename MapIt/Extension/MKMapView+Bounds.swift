//
//  MKMapView+Bounds.swift
//  Zip Route
//
//  Created by Jeff on 11/21/19.
//  Copyright © 2019 OverSphere LLC. All rights reserved.
//

import MapKit

extension MKMapView {
	func focus() {
			self.showAnnotations(self.annotations, animated: true)
	}
}
