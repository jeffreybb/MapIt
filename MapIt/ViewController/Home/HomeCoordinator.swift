//
//  HomeCoorinator.swift
//  Zip Route
//
//  Created by Jeff on 11/21/19.
//  Copyright © 2019 OverSphere LLC. All rights reserved.
//

import UIKit

final class HomeCoordinator: Coordinator {
	
	var navigationController: UINavigationController
	
	init(navigationController: UINavigationController) {
		self.navigationController = navigationController
	}
	
	func start() {
		let viewModel = HomeViewModel()
		let vc = HomeViewController(viewModel: viewModel, coordinator: self)
		navigationController.pushViewController(vc, animated: false)
	}
	
	func showNeedLocationAlert(completion: @escaping ()->()) {
		let ac = UIAlertController(title: "Hello traveller!", message: "in order to get you where you to go in the shortest amout of time, we're going to need to 'Always' have your location. Don't worry, this information never leaves your device and is only used to determine your optimal route, and navigate you to your destinations", preferredStyle: .alert)
		ac.addAction(UIAlertAction(title: "Understood", style: .default) { _ in
			completion()
		})
		navigationController.present(ac, animated: true)
	}
	
	func showSettings() {
		print("showing settings")
	}
	
	func showSearchResults(searchText: String, results: [LocationItem], completion: @escaping (LocationItem)->()) {
		let ac = UIAlertController(title: "Result for: \(searchText)", message: "select a location to add to your route", preferredStyle: .actionSheet)
		for item in results {
			
			let title: String
			if let areaOfInterest = item.name {
				title = "\(areaOfInterest), \(item.cityName)"
			} else {
				title = "\(item.streetAddress), \(item.cityName)"
			}
			
			ac.addAction(UIAlertAction(title: title, style: .default) { _ in
				completion(item)
			})
		}
		
		ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
		navigationController.present(ac, animated: true)
	}
	
	func showSearchFailureAlert() {
		let ac = UIAlertController(title: "No Results", message: "couldn't find any locations matching your search", preferredStyle: .alert)
		ac.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
		navigationController.present(ac, animated: true)
	}
	
}
