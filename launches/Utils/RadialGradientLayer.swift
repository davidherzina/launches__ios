//
// Created by David Herzina on 2019-08-01.
// Copyright (c) 2019 David Herzina. All rights reserved.
//

import UIKit


class RadialGradientLayer: CALayer
{

	var colors: [CGColor] = []
	{
		didSet
		{
			if self.colors != oldValue {
				self.setNeedsDisplay()
			}
		}
	}

	var locations: [CGFloat] = []
	{
		didSet
		{
			if self.locations != oldValue {
				self.setNeedsDisplay()
			}
		}
	}

	var startPoint: CGPoint?
	{
		didSet
		{
			if self.startPoint != oldValue {
				self.setNeedsDisplay()
			}
		}
	}

	var endPoint: CGPoint?
	{
		didSet
		{
			if self.endPoint != oldValue {
				self.setNeedsDisplay()
			}
		}
	}


	override func draw(in ctx: CGContext)
	{
		let p1 = CGPoint(
				x: self.startPoint?.x ?? 0.5,
				y: self.startPoint?.y ?? 0.5
		)

		let p2 = CGPoint(
				x: self.endPoint?.x ?? p1.x,
				y: self.endPoint?.y ?? p1.y
		)

		let viewPoint1 = CGPoint(
				x: self.bounds.width * p1.x,
				y: self.bounds.height * p1.y
		)

		let viewPoint2 = CGPoint(
				x: self.bounds.width * p2.x,
				y: self.bounds.height * p2.y
		)

		let radius = max(
				sqrt(pow(viewPoint1.x, 2) + pow(viewPoint2.x, 2)),
				sqrt(pow(viewPoint1.y, 2) + pow(viewPoint2.y, 2))
		)

		var colors = self.colors
		if colors.count == 0 {
			colors = [UIColor.blue.cgColor, UIColor.red.cgColor]
		}

		var locations = self.locations
		if locations.count == 0 {
			locations = [0, 1]
		}

		let colorSpace = CGColorSpaceCreateDeviceCMYK()
		guard let gradient = CGGradient(colorsSpace: colorSpace, colors: colors as CFArray, locations: locations) else {
			return
		}

		ctx.drawRadialGradient(
				gradient,
				startCenter: viewPoint1,
				startRadius: 0,
				endCenter: viewPoint1,
				endRadius: radius,
				options: .drawsAfterEndLocation
		)
	}
}
