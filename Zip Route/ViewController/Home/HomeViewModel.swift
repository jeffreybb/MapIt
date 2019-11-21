//
//  HomeViewModel.swift
//  Zip Route
//
//  Created by Jeff on 11/21/19.
//  Copyright © 2019 OverSphere LLC. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

protocol HomeViewModelDelegate: class {
	func homeViewModel(didUpdateCurrentLocation annotation: MKAnnotation)
	func homeViewModel(didUpdateSearchResults results: [LocationItem], searchText: String)
	func homeViewModelDidFailSearch()
}

final class HomeViewModel {
	
	// MARK: Internal
	func requestLocationAuthorization() {
		locationService.requestAuthorization()
	}
	
	func createAnnotation(forLocation location: CLLocation) -> MKAnnotation {
		let annotation = MKPointAnnotation()
		annotation.coordinate = location.coordinate
		return annotation
	}
	
	func searchForAddress(_ address: String) {
		print("searching for: \(address)")
		locationService.searchForMapItems(atAddress: address) { [weak self] (mapItems) in
			guard let mapItems = mapItems else {
				self?.delegate?.homeViewModelDidFailSearch()
				return
			}
			
			let locationItems = mapItems.map { LocationItem(mapItem: $0) }
			self?.delegate?.homeViewModel(didUpdateSearchResults: locationItems, searchText: address)
		}
	}
	
	weak var delegate: HomeViewModelDelegate?
	
	// MARK: Private
	
	private lazy var locationService = LocationService(delegate: self)

	init() {
		locationService.requestCurrentLocation()
	}
	
}

// MARK: - LocationServiceDelegate
extension HomeViewModel: LocationServiceDelegate {

	func locationService(_ service: LocationService, didUpdateCurrentLocation location: CLLocation) {
		let annotation = createAnnotation(forLocation: location)
		delegate?.homeViewModel(didUpdateCurrentLocation: annotation)
	}
	
	func locationService(_ service: LocationService, didFailWithError error: Error) {
		print("handle locationServiceDidFail")
	}

}
