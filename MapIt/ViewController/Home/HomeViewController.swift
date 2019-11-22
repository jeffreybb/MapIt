//
//  HomeViewController.swift
//  Zip Route
//
//  Created by Jeff on 11/21/19.
//  Copyright © 2019 OverSphere LLC. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

final class HomeViewController: UIViewController {
	
	private lazy var contentView = HomeView(delegate: self)

	override func loadView() {
		view = contentView
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupNavBar()
		setupTableDataSource()
	}
	
	// MARK: Private
	private func setupNavBar() {
		title = "MapIt"
		navigationItem.rightBarButtonItems = [contentView.addLocationButton, contentView.resetButton]
		navigationItem.leftBarButtonItem = contentView.settingsButton
	}
	
	private func setupTableDataSource() {
		tableDataSource = HomeTableDataSource(tableView: contentView.tableView, delgate: self)
	}
	
	// MARK: Init
	
	private let viewModel: HomeViewModel
	private let coordinator: HomeCoordinator
	private var tableDataSource: HomeTableDataSource!
	
	init(viewModel: HomeViewModel, coordinator: HomeCoordinator) {
		self.viewModel = viewModel
		self.coordinator = coordinator
		super.init(nibName: nil, bundle: nil)
		
		self.viewModel.delegate = self
	}
	
	// MARK: Required
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}

// MARK: - HomeViewDelegate
extension HomeViewController: HomeViewDelegate {
	
	func homeViewShouldShowSettings(_ view: HomeView) {
		coordinator.showSettings()
	}
	
	func homeViewShouldReset(_ view: HomeView) {
		tableDataSource.reset()
		contentView.clearMap()
	}
	
	func homeView(_ view: HomeView, shouldSearchWithText text: String) {
		viewModel.searchForAddress(text)
	}
	
	func homeViewShouldDisplayRoute(_ view: HomeView) {
		viewModel.calculateRoute()
	}
}

// MARK: - HomeTableDataSource
extension HomeViewController: HomeTableDataSourceDelegate {

	func homeTableDataSource(_ dataSource: HomeTableDataSource, shouldRemoveMapItem mapItem: MKMapItem) {
		let coordinate = mapItem.placemark.coordinate
		contentView.removeAnnotation(atCoordinate: coordinate)
		viewModel.removeMapItem(mapItem)
		viewModel.calculateRoute()
	}
	
	func homeTableDataSource(_ dataSource: HomeTableDataSource, didChangeNumberOfItems numberOfItems: Int) {
		
		if numberOfItems == 0 {
			contentView.showNoLocationsLabel()
		}
		
		if numberOfItems > 1 {
			contentView.showRouteButton()
		} else {
			contentView.hideRouteButton()
		}
	}
}

// MARK: - HomeViewModelDelegate
extension HomeViewController: HomeViewModelDelegate {
	func homeViewModel(didCaclulateRoute route: [MKRoute]) {
		print("Route Established: \(route)")
		DispatchQueue.main.async { [weak self] in
			self?.contentView.addRouteToMap(route: route)
		}
	}
	
	
	func homeViewModelDidFailSearch() {
		contentView.stopActivityIndicator()
		coordinator.showSearchFailureAlert()
	}
	
	func homeViewModel(didUpdateSearchResults results: [LocationItem], searchText: String) {
		DispatchQueue.main.async { [weak self] in
			self?.contentView.stopActivityIndicator()
			
			self?.coordinator.showSearchResults(searchText: searchText, results: results, completion: { (item) in
				
				self?.contentView.hideNoLocationsLabel()
				self?.tableDataSource.add(item: item)
				self?.viewModel.addSelectedMapItem(item.mapItem)
				
				guard let annotation = self?.viewModel.createAnnotation(forLocation: item.mapItem.placemark.location) else { return }
				
				self?.contentView.addAnnotationToMap(annotation)
			})
			
		}
		
	}

	func homeViewModel(didUpdateCurrentLocation annotation: MKAnnotation) {
		tableDataSource.currentUserLocation = annotation.location
	}

}

