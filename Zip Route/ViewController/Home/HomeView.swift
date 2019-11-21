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
	
}

final class HomeView: UIView {
	
	private let mapView: MKMapView = {
		let view = MKMapView()
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	private func setupView() {
		
	}
	
	private func setupSubviews() {
		addSubview(mapView)
		addSubview(tableView)
		
		fillHorizontally(with: mapView)
		fillHorizontally(with: tableView)
		
		NSLayoutConstraint.activate([
			mapView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
			mapView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/3),
			
			tableView.topAnchor.constraint(equalTo: mapView.bottomAnchor),
			tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
		])
		
		
	}
	
	private unowned let delegate: HomeViewDelegate
	
	init(delegate: HomeViewDelegate) {
		self.delegate = delegate
		super.init(frame: .zero)
		
		setupView()
		setupSubviews()
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
