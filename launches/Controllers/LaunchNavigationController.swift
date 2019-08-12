//
// Created by David Herzina on 2019-08-01.
// Copyright (c) 2019 David Herzina. All rights reserved.
//

import UIKit


class LaunchNavigationController: NavigationController
{

	let list = LaunchListController()


	override func viewDidLoad()
	{
		super.viewDidLoad()

		viewControllers = [list]
		setNeedsStatusBarAppearanceUpdate()
	}


	override var preferredStatusBarStyle: UIStatusBarStyle
	{
		return .lightContent
	}
}
