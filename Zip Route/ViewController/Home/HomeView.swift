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
	func homeViewShouldCalculateRoute(_ view: HomeView)
}

final class HomeView: UIView {
	
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
	
	private lazy var button: UIButton = {
		let button = UIButton()
		button.backgroundColor = .systemTeal
		button.setTitle("Caculate Route", for: [])
		button.setTitleColor(.white, for: [])
		button.layer.cornerRadius = 52/2
		button.layer.shadowColor = UIColor.systemGray3.cgColor
		button.layer.shadowOpacity = 1
		button.layer.shadowRadius = 10
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
		addSubview(button)
		
		fillHorizontally(with: mapView)
		fillHorizontally(with: tableView)
		fillHorizontally(with: noLocationsLabel, withPadding: 44)
		fillHorizontally(with: searchTextField, withPadding: 22)
		
		searchBarHeightContraint = searchTextField.heightAnchor.constraint(equalToConstant: 0)
		buttonWidthContraint = button.widthAnchor.constraint(equalToConstant: 0)
		
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
			
			button.centerXAnchor.constraint(equalTo: centerXAnchor),
			button.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -12),
			button.heightAnchor.constraint(equalToConstant: 52),
			buttonWidthContraint
		])
	}
	
	private func animateViews() {
		UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 10, options: .curveEaseInOut, animations: {
			self.layoutIfNeeded()
		}, completion: nil)
	}
	
	private var buttonWidthContraint: NSLayoutConstraint!
	private var searchBarHeightContraint: NSLayoutConstraint!
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
	func showSearchBar() {
		searchBarHeightContraint.constant = 44
		animateViews()
		searchTextField.becomeFirstResponder()
	}
	
	func hideSearchBar() {
		searchBarHeightContraint.constant = 0
		animateViews()
	}
	
	func showCaclulateButton() {
		buttonWidthContraint.constant = UIScreen.main.bounds.width - 44.0
		animateViews()
	}
	
	func hideCalculateButton() {
		buttonWidthContraint.constant = 0
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
	
	let tableView: UITableView = {
		let tv = UITableView()
		tv.rowHeight = 62
		tv.tableFooterView = UIView()
		tv.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 92, right: 0)
		tv.translatesAutoresizingMaskIntoConstraints = false
		return tv
	}()
	
	func addAnnotationToMap(_ annotation: MKAnnotation) {
		mapView.addAnnotation(annotation)
		mapView.focus()
	}
	
	func removeAnnotation(atLocation location: CLLocation) {
		guard let annotation = mapView.annotations.first(where: { ($0.coordinate.latitude == location.coordinate.latitude) && ($0.coordinate.longitude == location.coordinate.longitude) }) else {
			print("no annotation at location: \(location)")
			return
		}
		
		mapView.removeAnnotation(annotation)
		mapView.focus()
	}
	
	func removeAllAnnotations() {
		mapView.removeAnnotations(mapView.annotations)
	}
	
	// MARK: Required
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}

// MARK: - MKMapViewDelegate
extension HomeView: MKMapViewDelegate {

	func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
		
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
