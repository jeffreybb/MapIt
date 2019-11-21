//
//  HomeViewModel.swift
//  Zip Route
//
//  Created by Jeff on 11/21/19.
//  Copyright © 2019 OverSphere LLC. All rights reserved.
//

import Foundation

protocol HomeViewModelDelegate: class {
	
}

final class HomeViewModel {
	
	weak var delegate: HomeViewDelegate?
	
	private lazy var locationService = LocationService(delegate: self)
	
}

// MARK: - LocationServiceDelegate
extension HomeViewModel: LocationServiceDelegate {
	func locationService(_ service: LocationService, didFailWithError error: Error) {
		print("handle locationServiceDidFail")
	}

}
