//
//  HomeViewController.swift
//  Zip Route
//
//  Created by Jeff on 11/21/19.
//  Copyright © 2019 OverSphere LLC. All rights reserved.
//

import UIKit

final class HomeViewController: UIViewController {
	
	private lazy var contentView = HomeView(delegate: self)
	private lazy var addLocationButton = UIBarButtonItem(image: UIImage(systemName: "mappin.and.ellipse"), style: .plain, target: self, action: #selector(handleAddNewLocation))
	private lazy var settingsButton = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: self, action: #selector(handleSettings))
	
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
		navigationItem.rightBarButtonItem = addLocationButton
		navigationItem.leftBarButtonItem = settingsButton
	}
	
	private func setupTableDataSource() {
		tableDataSource = HomeTableDataSource(tableView: contentView.tableView, delgate: self)
	}
	
	// MARK: Handler
	@objc func handleAddNewLocation() {
		
	}
	
	@objc func handleSettings() {
		coordinator.showSettings()
	}
	
	// MARK: Init
	
	private let viewModel: HomeViewModel
	private let coordinator: HomeCoordinator
	private var tableDataSource: HomeTableDataSource!
	
	init(viewModel: HomeViewModel, coordinator: HomeCoordinator) {
		self.viewModel = viewModel
		self.coordinator = coordinator
		super.init(nibName: nil, bundle: nil)
	}
	
	// MARK: Required
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}

// MARK: - HomeViewDelegate
extension HomeViewController: HomeViewDelegate {
	
}

// MARK: - HomeTableDataSource
extension HomeViewController: HomeTableDataSourceDelegate {
	
}