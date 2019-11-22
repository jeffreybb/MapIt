//
//  Double+FormattedDistance.swift
//  Zip Route
//
//  Created by Jeff on 11/21/19.
//  Copyright © 2019 OverSphere LLC. All rights reserved.
//

import Foundation

extension Double {
	
	var formattedDistance: String {
		let distance = self * 0.000621371
		return "\(String(format: "%.1f", distance))mi"
	}
	
}
