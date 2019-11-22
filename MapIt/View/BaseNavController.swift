//
//  BaseNavController.swift
//  Zip Route
//
//  Created by Jeff on 11/21/19.
//  Copyright © 2019 OverSphere LLC. All rights reserved.
//

import UIKit

final class BaseNavController: UINavigationController {
	
	private func setup() {
		navigationBar.barTintColor = .systemBackground
		navigationBar.isTranslucent = false
		navigationBar.tintColor = .systemTeal
		navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.label]
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setup()
	}

}
