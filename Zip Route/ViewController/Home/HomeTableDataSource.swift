//
//  HomeTableDataSource.swift
//  Zip Route
//
//  Created by Jeff on 11/21/19.
//  Copyright © 2019 OverSphere LLC. All rights reserved.
//

import UIKit
import CoreLocation

protocol HomeTableDataSourceDelegate: class {
	
}

final class HomeTableDataSource: NSObject {
	
	private unowned let delegate: HomeTableDataSourceDelegate
	private let tableView: UITableView
	private var items = [LocationItem]()
	private var currentLocation: CLLocation?
	
	init(tableView: UITableView, delgate: HomeTableDataSourceDelegate) {
		self.tableView = tableView
		self.delegate = delgate
		super.init()
		
		setupTableView()
	}
	
	private func setupTableView() {
		tableView.register(HomeTableCell.self, forCellReuseIdentifier: HomeTableCell.resuseIdentifier)
		tableView.dataSource = self
		tableView.delegate = self
	}
	
	// MARK: Internal
	func add(item: LocationItem) {
		items.append(item)
		tableView.reloadData()
	}
	
}

// MARK: - UITableViewDataSource
extension HomeTableDataSource: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return items.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableCell.resuseIdentifier, for: indexPath)
		
		let item = items[indexPath.row]

		cell.textLabel?.text = item.address
		cell.imageView?.image = UIImage(systemName: "mappin")
		cell.imageView?.tintColor = .systemTeal
		
		let detailText: String
		if let currentLocation = currentLocation,
			 let distanceFromCurrentLocation = item.getDistanceFromCurrentLocation(currentLocation: currentLocation) {
			detailText = "\(distanceFromCurrentLocation) meters away"
		} else {
			detailText = "unable to determine distance"
		}
		cell.detailTextLabel?.text = detailText
		
		return cell
	}
}

// MARK: - UITableViewDelegate
extension HomeTableDataSource: UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 52
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let view = UIView()
		view.backgroundColor = .systemBackground
		view.heightAnchor.constraint(equalToConstant: 52).isActive = true
		
		let label = UILabel()
		view.addSubview(label)
		
		label.translatesAutoresizingMaskIntoConstraints = false
		label.text = "Locations"
		label.font = .systemFont(ofSize: 16, weight: .medium)
		label.textColor = .secondaryLabel
		label.textAlignment = .left
		label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
		label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12).isActive = true
		
		return view
	}
}
