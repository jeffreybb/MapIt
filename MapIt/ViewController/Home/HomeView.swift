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
	func homeView(_ view: HomeView, shouldSearchWithText text: String)
	func homeViewShouldDisplayRoute(_ view: HomeView)
	func homeViewShouldShowSettings(_ view: HomeView)
	func homeViewShouldReset(_ view: HomeView)
}

final class HomeView: UIView {
	
	// MARK: Private
	private lazy var mapView: MKMapView = {
		let view = MKMapView()
		view.delegate = self
		view.showsUserLocation = true
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	private let noLocationsLabel: UILabel = {
		let label = UILabel()
		label.numberOfLines = 0
		label.textAlignment = .center
		label.textColor = .systemTeal
		label.text = "Tap 📍 to start\nadding locations to your route"
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	private let activityIndicatorView: UIActivityIndicatorView = {
		let view = UIActivityIndicatorView(style: .medium)
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	private lazy var searchTextField: UITextField = {
		let tf = UITextField()
		tf.backgroundColor = .systemGray6
		tf.layer.borderWidth = 2
		tf.layer.borderColor = UIColor.white.cgColor
		tf.layer.cornerRadius = 22
		tf.layer.shadowColor = UIColor.systemGray.cgColor
		tf.layer.shadowOpacity = 0.2
		tf.layer.shadowRadius = 5
		tf.layer.shadowOffset = CGSize(width: 0, height: 1)
		tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: tf.frame.height))
		tf.leftViewMode = .always
		tf.returnKeyType = .search
		tf.delegate = self
		tf.placeholder = "Search for address"
		tf.layer.shadowOffset = CGSize(width: 0, height: 1)
		tf.translatesAutoresizingMaskIntoConstraints = false
		return tf
	}()
	
	private lazy var displayRouteButton: UIButton = {
		let button = UIButton()
		button.backgroundColor = .systemTeal
		button.setTitle("Display Route", for: [])
		button.setTitleColor(.white, for: [])
		button.layer.cornerRadius = 52/2
		button.layer.shadowColor = UIColor.systemGray3.cgColor
		button.layer.shadowOpacity = 0.2
		button.layer.shadowRadius = 5
		button.layer.shadowOffset = CGSize(width: 0, height: 1)
		button.layer.borderColor = UIColor.white.cgColor
		button.layer.borderWidth = 2
		button.titleLabel?.font = .systemFont(ofSize: 22, weight: .regular)
		button.addTarget(self, action: #selector(handleCalculateRoute), for: .touchUpInside)
		button.translatesAutoresizingMaskIntoConstraints = false
		return button
	}()
	
	private func setupView() {
		backgroundColor = .systemBackground
	}
	
	private func setupSubviews() {
		addSubview(mapView)
		addSubview(activityIndicatorView)
		addSubview(searchTextField)
		addSubview(tableView)
		addSubview(noLocationsLabel)
		addSubview(displayRouteButton)
		
		fillHorizontally(with: mapView)
		fillHorizontally(with: tableView)
		fillHorizontally(with: noLocationsLabel, withPadding: 44)
		fillHorizontally(with: searchTextField, withPadding: 22)
		
		searchBarHeightContraint = searchTextField.heightAnchor.constraint(equalToConstant: 0)
		routeButtonWidthContraint = displayRouteButton.widthAnchor.constraint(equalToConstant: 0)
		
		NSLayoutConstraint.activate([
			mapView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
			mapView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/3),
			
			activityIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor),
			activityIndicatorView.centerYAnchor.constraint(equalTo: searchTextField.centerYAnchor),
			
			searchTextField.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 18),
			searchBarHeightContraint,
			
			tableView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 14),
			tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
			
			noLocationsLabel.topAnchor.constraint(equalTo: tableView.topAnchor, constant: 64),
			
			displayRouteButton.centerXAnchor.constraint(equalTo: centerXAnchor),
			displayRouteButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -12),
			displayRouteButton.heightAnchor.constraint(equalToConstant: 52),
			routeButtonWidthContraint
		])
	}
	
	private func animateViews() {
		UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 10, options: .curveEaseInOut, animations: {
			self.layoutIfNeeded()
		}, completion: nil)
	}
	
	private var routeButtonWidthContraint: NSLayoutConstraint!
	private var searchBarHeightContraint: NSLayoutConstraint!
	
	// MARK: Init
	private unowned let delegate: HomeViewDelegate
	
	init(delegate: HomeViewDelegate) {
		self.delegate = delegate
		super.init(frame: .zero)
		
		setupView()
		setupSubviews()
	}
	
	// MARK: Handler
	@objc func handleCalculateRoute() {
		mapView.removeOverlays(mapView.overlays)
		delegate.homeViewShouldDisplayRoute(self)
	}
	
	// MARK: Internal
	// Properties
	lazy var addLocationButton: UIBarButtonItem = {
		return UIBarButtonItem(image: UIImage(systemName: "mappin.and.ellipse"),
													 style: .plain, target: self,
													 action: #selector(handleAddNewLocation))
	}()
	
	lazy var settingsButton: UIBarButtonItem = {
		return UIBarButtonItem(image: UIImage(systemName: "gear"),
													 style: .plain, target: self,
													 action: #selector(handleSettings))
	}()
	
	lazy var resetButton: UIBarButtonItem = {
		return UIBarButtonItem(image: UIImage(systemName: "arrow.counterclockwise"),
													 style: .plain, target: self,
													 action: #selector(handleReset))
	}()
	
	let tableView: UITableView = {
		let tv = UITableView()
		tv.rowHeight = 62
		tv.tableFooterView = UIView()
		tv.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 92, right: 0)
		tv.translatesAutoresizingMaskIntoConstraints = false
		return tv
	}()
	
	// Methods
	func showSearchBar() {
		searchBarHeightContraint.constant = 44
		animateViews()
		searchTextField.becomeFirstResponder()
	}
	
	func hideSearchBar() {
		searchBarHeightContraint.constant = 0
		animateViews()
	}
	
	func showRouteButton() {
		routeButtonWidthContraint.constant = UIScreen.main.bounds.width - 44.0
		animateViews()
	}
	
	func hideRouteButton() {
		routeButtonWidthContraint.constant = 0
		animateViews()
	}
	
	func stopActivityIndicator() {
		activityIndicatorView.stopAnimating()
	}
	
	func hideNoLocationsLabel() {
		UIView.animate(withDuration: 0.2) {
			self.noLocationsLabel.alpha = 0
		}
	}
	
	func showNoLocationsLabel() {
		UIView.animate(withDuration: 0.2) {
			self.noLocationsLabel.alpha = 1
		}
	}
	
	func addAnnotationToMap(_ annotation: MKAnnotation) {
		mapView.addAnnotation(annotation)
		mapView.removeOverlays(mapView.overlays)
		mapView.focus()
	}
	
	func removeAnnotation(atCoordinate coordinate: CLLocationCoordinate2D) {
		guard let annotation = mapView.annotations.first(where: { ($0.coordinate.latitude == coordinate.latitude)
																													&& ($0.coordinate.longitude == coordinate.longitude) })
		else { return }
		
		mapView.removeAnnotation(annotation)
		mapView.removeOverlays(mapView.overlays)
		mapView.focus()
	}
	
	func clearMap() {
		mapView.removeAnnotations(mapView.annotations)
		mapView.removeOverlays(mapView.overlays)
		mapView.focus()
		showNoLocationsLabel()
	}
	
	func addRouteToMap(route: [MKRoute]) {
		let polylines = route.map { $0.polyline }
		
		mapView.addOverlays(polylines, level: .aboveRoads)
	}
	
	// MARK: Handler
	@objc func handleAddNewLocation() {
		showSearchBar()
	}
	
	@objc func handleSettings() {
		delegate.homeViewShouldShowSettings(self)
	}
	
	@objc func handleReset() {
		delegate.homeViewShouldReset(self)
	}
	
	// MARK: Required
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}

// MARK: - UITextFieldDelegate
extension HomeView: UITextFieldDelegate {
	
	func textFieldDidBeginEditing(_ textField: UITextField) {
		textField.becomeFirstResponder()
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		guard let text = textField.text else { return true }
		
		delegate.homeView(self, shouldSearchWithText: text)
		textField.text = nil
		textField.resignFirstResponder()
		hideSearchBar()
		activityIndicatorView.startAnimating()
		return true
	}
}

// MARK: - MKMapViewDelegate
extension HomeView: MKMapViewDelegate {
	func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
		if overlay is MKPolyline {
			let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
			renderer.lineWidth = 5
			
			guard mapView.overlays.count > 0 else { return renderer }
			
			let index = mapView.overlays.count - 1
			renderer.strokeColor = index < R.Color.polyline.endIndex
				? R.Color.polyline[index]
				: .systemTeal
			
			return renderer
		} else {
			return MKOverlayRenderer(overlay: overlay)
		}
	}
}
