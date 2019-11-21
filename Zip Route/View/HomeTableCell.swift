//
//  HomeTableCell.swift
//  Zip Route
//
//  Created by Jeff on 11/21/19.
//  Copyright © 2019 OverSphere LLC. All rights reserved.
//

import UIKit
import MapKit

final class HomeTableCell: UITableViewCell {
	
	static let resuseIdentifier = String.init(describing: self)
	
	private let distanceLabel: UILabel = {
		let label = UILabel()
		label.textColor = .secondaryLabel
		label.font = .systemFont(ofSize: 12, weight: .regular)
		label.textAlignment = .right
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
		
		setupSubviews()
	}
	
	private func setupSubviews() {
		contentView.addSubview(distanceLabel)
		
		distanceLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
		distanceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -22).isActive = true
		
		textLabel?.font = .systemFont(ofSize: 16, weight: .regular)
	}
	
	// MARK: Internal
	func configure(withItem item: LocationItem, currentUserLocation: CLLocation?) {
		
		
		
		textLabel?.text = item.name != nil ? item.name! : item.streetAddress
		detailTextLabel?.text = item.cityName
		imageView?.image = UIImage(systemName: "mappin")
		imageView?.tintColor = .systemTeal
		
		if let currentLocation = currentUserLocation, let distance = item.distanceFrom(currentLocation: currentLocation) {
			distanceLabel.text = distance.formattedDistance
		}
		
	}
	
	// MARK: Required
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
}
