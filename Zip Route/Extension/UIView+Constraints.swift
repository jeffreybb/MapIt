//
//  UIView+Constraints.swift
//  Zip Route
//
//  Created by Jeff on 11/21/19.
//  Copyright © 2019 OverSphere LLC. All rights reserved.
//

import UIKit

extension UIView {
	
	private func addConstraintsWith(format: String, views: UIView...) {
		var viewsDictionary = [String: UIView]()
		for (index, view) in views.enumerated() {
			let key = "v\(index)"
			view.translatesAutoresizingMaskIntoConstraints = false
			viewsDictionary[key] = view
		}
		
		addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
	}
	
	func fillHorizontally(with view: UIView, withPadding padding: CGFloat = 0.0) {
		addConstraintsWith(format: "H:|-\(padding)-[v0]-\(padding)-|", views: view)
	}
	
	func fillVertically(with view: UIView, withPadding padding: CGFloat = 0.0) {
		addConstraintsWith(format: "V:|-\(padding)-[v0]-\(padding)-|", views: view)
	}
	
	func fill(with view: UIView, withPadding padding: CGFloat = 0.0) {
		fillHorizontally(with: view, withPadding: padding)
		fillVertically(with: view, withPadding: padding)
	}
	
}

