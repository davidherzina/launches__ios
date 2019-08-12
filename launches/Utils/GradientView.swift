//
// Created by David Herzina on 2019-08-12.
// Copyright (c) 2019 David Herzina. All rights reserved.
//

import UIKit


class GradientView: UIView
{
	let gradient = CAGradientLayer()

	var shouldReloadAutomatically: Bool = true


	init()
	{
		super.init(frame: .zero)
		layout()
	}


	required init?(coder aDecoder: NSCoder)
	{
		super.init(coder: aDecoder)
		layout()
	}


	fileprivate func layout()
	{
		layer.addSublayer(gradient)
		backgroundColor = .clear
	}


	override func layoutSubviews()
	{
		super.layoutSubviews()

		if (!shouldReloadAutomatically) {
			return
		}

		UIView.performWithoutAnimation
		{
			self.gradient.frame = bounds
		}
	}
}