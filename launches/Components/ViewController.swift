//
//  ViewController.swift
//  launches
//
//  Created by David Herzina on 01/08/2019.
//  Copyright © 2019 David Herzina. All rights reserved.
//

import UIKit

class Controller: UIViewController
{


	override func viewDidLoad()
	{
		super.viewDidLoad()
		background()
	}


	fileprivate func background()
	{
		let layer = RadialGradientLayer()
		layer.colors = [
			UIColor.appBackgroundOne.cgColor,
			UIColor.appBackgroundTwo.cgColor
		]

		layer.locations = [0.0, 0.4]
		layer.startPoint = CGPoint(x: 0.333, y: 0.1)
		layer.endPoint = CGPoint(x: 0.5, y: 1.0)
		layer.isOpaque = false

		layer.frame = view.bounds
		view.layer.addSublayer(layer)
	}


	override var preferredStatusBarStyle: UIStatusBarStyle
	{
		return .lightContent
	}
}

