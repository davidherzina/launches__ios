//
//  AppDelegate.swift
//  launches
//
//  Created by David Herzina on 01/08/2019.
//  Copyright © 2019 David Herzina. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{

	var window: UIWindow?


	// Override point for customization after application launch.
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
	{
		window = UIWindow(frame: UIScreen.main.bounds)
		window?.rootViewController = LaunchNavigationController()
		window?.makeKeyAndVisible()

		return true
	}
}

