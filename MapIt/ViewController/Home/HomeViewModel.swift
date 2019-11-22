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
	func homeViewModel(didCaclulateRoute route: [MKRoute])
	func homeViewModel(didUpdateCurrentLocation annotation: MKAnnotation)
	func homeViewModel(didUpdateSearchResults results: [LocationItem], searchText: String)
	func homeViewModelDidFailSearch()
}

final class HomeViewModel {
	
	// MARK: Internal
	func reset() {
		mapItems.removeAll()
	}
	
	func requestLocationAuthorization() {
		locationService.requestAuthorization()
	}
	
	func createAnnotation(forLocation location: CLLocation) -> MKAnnotation {
		let annotation = MKPointAnnotation()
		annotation.coordinate = location.coordinate
		return annotation
	}
	
	func searchForAddress(_ address: String) {
		
		locationService.searchForMapItems(atAddress: address) { [weak self] (mapItems) in
			guard let mapItems = mapItems else {
				self?.delegate?.homeViewModelDidFailSearch()
				return
			}
			
			let locationItems = mapItems.map { LocationItem(mapItem: $0) }
			self?.delegate?.homeViewModel(didUpdateSearchResults: locationItems, searchText: address)
		}
	}
	
	func addSelectedMapItem(_ mapItem: MKMapItem) {
		mapItems.append(mapItem)
	}
	
	func removeMapItem(_ mapItem: MKMapItem) {
		guard let index = mapItems.firstIndex(of: mapItem) else { return }
		
		mapItems.remove(at: index)
	}
	
	private var calculationInProgress = false
	
	func calculateRoute() {
		if calculationInProgress {
			return
		}
		calculationInProgress = true
		
		if let userMapItem = userMapItem {
			mapItems.append(userMapItem)
		}
		
		locationService.requestRoute(forMapItems: mapItems) { [weak self] (route) in
			self?.delegate?.homeViewModel(didCaclulateRoute: route)
			self?.calculationInProgress = false
		}
	}
	
	weak var delegate: HomeViewModelDelegate?
	
	// MARK: Private
	private var userMapItem: MKMapItem?
	private var mapItems = [MKMapItem]()
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
		print("userLocationUpdated")
		if userMapItem == nil {
			let placemark = MKPlacemark(coordinate: location.coordinate)
			let mapItem = MKMapItem(placemark: placemark)
			userMapItem = mapItem
			mapItems.append(mapItem)
		}
		
	}
	
	func locationService(_ service: LocationService, didFailWithError error: Error) {
		print("handle locationServiceDidFail")
	}

}
