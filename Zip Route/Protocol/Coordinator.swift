//
//  Coordinator.swift
//  Zip Route
//
//  Created by Jeff on 11/21/19.
//  Copyright © 2019 OverSphere LLC. All rights reserved.
//

import UIKit

protocol Coordinator {
	var navigationController: UINavigationController { get set }
	func start()
}
