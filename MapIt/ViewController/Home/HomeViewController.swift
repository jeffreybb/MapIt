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
	
	private lazy var addLocationButton = UIBarButtonItem(image: UIImage(systemName: "mappin.and.ellipse"), style: .plain, target: self, action: #selector(handleAddNewLocation))
	private lazy var settingsButton = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: self, action: #selector(handleSettings))
	private lazy var resetButton = UIBarButtonItem(image: UIImage(systemName: "arrow.counterclockwise"), style: .plain, target: self, action: #selector(handleReset))
	
	override func loadView() {
		view = contentView
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupNavBar()
		setupTableDataSource()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		
		
//		coordinator.showNeedLocationAlert { [weak self] in
//			self?.viewModel.requestLocationAuthorization()
//		}
	}
	
	// MARK: Private
	private func setupNavBar() {
		title = "MapIt"
		navigationItem.rightBarButtonItems = [addLocationButton, resetButton]
		navigationItem.leftBarButtonItem = settingsButton

	}
	
	private func setupTableDataSource() {
		tableDataSource = HomeTableDataSource(tableView: contentView.tableView, delgate: self)
	}
	
	// MARK: Handler
	@objc func handleAddNewLocation() {
		contentView.showSearchBar()
	}
	
	@objc func handleSettings() {
		coordinator.showSettings()
	}
	
	@objc func handleReset() {
		tableDataSource.reset()
		contentView.removeAllAnnotations()
		contentView.showNoLocationsLabel()
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
	func homeView(_ view: HomeView, shouldSearchWithText text: String) {
		viewModel.searchForAddress(text)
	}
	
	func homeViewShouldCalculateRoute(_ view: HomeView) {
		print("calculating route")
	}
	
	
}

// MARK: - HomeTableDataSource
extension HomeViewController: HomeTableDataSourceDelegate {
	func homeTableDataSource(_ dataSource: HomeTableDataSource, shouldRemoveAnnotationFoLocation location: CLLocation) {
		contentView.removeAnnotation(atLocation: location)
	}
	
	
	func homeTableDataSource(_ dataSource: HomeTableDataSource, didChangeNumberOfItems numberOfItems: Int) {
		
		if numberOfItems == 0 {
			contentView.showNoLocationsLabel()
		}
		
		if numberOfItems > 1 {
			contentView.showCaclulateButton()
		} else {
			contentView.hideCalculateButton()
		}
	}
}

// MARK: - HomeViewModelDelegate
extension HomeViewController: HomeViewModelDelegate {
	
	
	func homeViewModelDidFailSearch() {
		contentView.stopActivityIndicator()
		coordinator.showSearchFailureAlert()
	}
	
	func homeViewModel(didUpdateSearchResults results: [LocationItem], searchText: String) {
		DispatchQueue.main.async { [weak self] in
			self?.contentView.stopActivityIndicator()
			
			self?.coordinator.showSearchResults(searchText: searchText, items: results, completion: { (item) in
				self?.contentView.hideNoLocationsLabel()
				self?.tableDataSource.add(item: item)
				
				guard let annotation = self?.viewModel.createAnnotation(forLocation: item.mapItem.placemark.location) else { return }
				
				self?.contentView.addAnnotationToMap(annotation)
			})
			
		}
		
	}

	func homeViewModel(didUpdateCurrentLocation annotation: MKAnnotation) {
		tableDataSource.currentUserLocation = annotation.location
//		contentView.addAnnotationToMap(annotation)
	}

}
