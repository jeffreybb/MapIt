//
//  HomeTableDataSource.swift
//  Zip Route
//
//  Created by Jeff on 11/21/19.
//  Copyright © 2019 OverSphere LLC. All rights reserved.
//

import UIKit

protocol HomeTableDataSourceDelegate: class {
	
}

final class HomeTableDataSource: NSObject {
	
	private unowned let delegate: HomeTableDataSourceDelegate
	private let tableView: UITableView
	
	init(tableView: UITableView, delgate: HomeTableDataSourceDelegate) {
		self.tableView = tableView
		self.delegate = delgate
		super.init()
		
		setupTableView()
	}
	
	private func setupTableView() {
		tableView.register(HomeTableCell.self, forCellReuseIdentifier: HomeTableCell.resuseIdentifier)
		tableView.dataSource = self
	}
	
	// MARK: Internal
	func addItem() {
		
	}
	
}

// MARK:
extension HomeTableDataSource: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 5
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableCell.resuseIdentifier, for: indexPath)
		cell.textLabel?.text = "123 Fake St., Boston"
		cell.detailTextLabel?.text = "5mi away"
		cell.imageView?.image = UIImage(systemName: "mappin")
		cell.imageView?.tintColor = .systemTeal
		return cell
	}
	
	
}
