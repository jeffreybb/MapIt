//
//  AppDelegate.swift
//  Zip Route
//
//  Created by Jeff on 11/21/19.
//  Copyright © 2019 OverSphere LLC. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	
	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

		setupWindow()
		return true
	}

	private func setupWindow() {
		
		window = UIWindow(frame: UIScreen.main.bounds)
		window?.makeKeyAndVisible()
		
		let nc = BaseNavController()
		let coordinator = HomeCoordinator(navigationController: nc)
		window?.rootViewController = nc
		coordinator.start()
		
	}
	
}

