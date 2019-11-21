//
//  HomeView.swift
//  Zip Route
//
//  Created by Jeff on 11/21/19.
//  Copyright © 2019 OverSphere LLC. All rights reserved.
//

import UIKit
import MapKit

protocol HomeViewDelegate: class {
	func homeViewShouldCalculateRoute(_ view: HomeView)
}

final class HomeView: UIView {
	
	private lazy var mapView: MKMapView = {
		let view = MKMapView()
		view.delegate = self
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	private lazy var calculateButton: UIButton = {
		let button = UIButton()
		button.backgroundColor = .systemTeal
		button.setTitle("Caculate Route", for: [])
		button.setTitleColor(.white, for: [])
		button.titleLabel?.font = .systemFont(ofSize: 22, weight: .medium)
		button.addTarget(self, action: #selector(handleCalculateRoute), for: .touchUpInside)
		button.translatesAutoresizingMaskIntoConstraints = false
		return button
	}()
	
	private func setupView() {
		backgroundColor = .systemTeal
	}
	
	private func setupSubviews() {
		addSubview(mapView)
		addSubview(tableView)
		addSubview(calculateButton)
		
		fillHorizontally(with: mapView)
		fillHorizontally(with: tableView)
		fillHorizontally(with: calculateButton)
		
		NSLayoutConstraint.activate([
			mapView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
			mapView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/3),
			
			tableView.topAnchor.constraint(equalTo: mapView.bottomAnchor),
			tableView.bottomAnchor.constraint(equalTo: calculateButton.topAnchor),
			
			calculateButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
			calculateButton.heightAnchor.constraint(equalToConstant: 60)
		])
		
		
	}
	
	private unowned let delegate: HomeViewDelegate
	
	init(delegate: HomeViewDelegate) {
		self.delegate = delegate
		super.init(frame: .zero)
		
		setupView()
		setupSubviews()
	}
	
	// MARK: Handler
	@objc func handleCalculateRoute() {
		delegate.homeViewShouldCalculateRoute(self)
	}
	
	// MARK: Internal
	let tableView: UITableView = {
		let tv = UITableView()
		tv.rowHeight = 62
		tv.translatesAutoresizingMaskIntoConstraints = false
		return tv
	}()
	
	// MARK: Required
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}

// MARK: - MKMapViewDelegate
extension HomeView: MKMapViewDelegate {
	
}
