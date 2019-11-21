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
	func homeTableDataSource(_ dataSource: HomeTableDataSource, didChangeNumberOfItems numberOfItems: Int)
	func homeTableDataSource(_ dataSource: HomeTableDataSource, shouldRemoveAnnotationFoLocation location: CLLocation)
}

final class HomeTableDataSource: NSObject {
	
	private unowned let delegate: HomeTableDataSourceDelegate
	private let tableView: UITableView
	private var items = [LocationItem]()
	
	
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
	var currentUserLocation: CLLocation?
	
	func add(item: LocationItem) {
		items.append(item)
		tableView.reloadData()
		updateNumberOfItems()
	}
	
	func reset() {
		items = [LocationItem]()
		tableView.reloadData()
		updateNumberOfItems()
	}
	
	func updateNumberOfItems() {
		delegate.homeTableDataSource(self, didChangeNumberOfItems: items.count)
	}
}

// MARK: - UITableViewDataSource
extension HomeTableDataSource: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return items.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableCell.resuseIdentifier, for: indexPath) as? HomeTableCell else { fatalError() }
		
		let item = items[indexPath.row]
		cell.configure(withItem: item, currentUserLocation: currentUserLocation)
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
	
	func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		let delete = UIContextualAction(style: .destructive, title: "Remove") { [weak self] (action, _, completion) in
			
			guard let aSelf = self else { return }
			
			if let location = aSelf.items[indexPath.row].mapItem.placemark.location {
				aSelf.delegate.homeTableDataSource(aSelf, shouldRemoveAnnotationFoLocation: location)
			}
			
			aSelf.items.remove(at: indexPath.row)
			tableView.deleteRows(at: [indexPath], with: .automatic)
			aSelf.updateNumberOfItems()
			
			completion(true)
		}
		let config = UISwipeActionsConfiguration(actions: [delete])
		return config
	}
}
