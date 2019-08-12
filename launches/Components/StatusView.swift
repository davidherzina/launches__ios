//
// Created by David Herzina on 2019-08-12.
// Copyright (c) 2019 David Herzina. All rights reserved.
//

import UIKit
import SnapKit


class StatusView: UIView
{

	var title: String?
	{
		didSet
		{
			update()
		}
	}

	var icon: UIImage?
	{
		didSet
		{
			update()
		}
	}

	let backgroundView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))

	let imageView = UIImageView()

	let titleLabel = UILabel()


	init()
	{
		super.init(frame: .zero)
		create()
	}


	required init?(coder aDecoder: NSCoder)
	{
		super.init(coder: aDecoder)
		create()
	}


	fileprivate func create()
	{
		backgroundColor = .clear
		layer.cornerRadius = 12
		clipsToBounds = true

		layoutBackgroundView()
		layoutImageView()
		layoutTitleLabel()

		update()
	}


	fileprivate func update()
	{
		titleLabel.text = title?.uppercased()
		imageView.image = icon?.withRenderingMode(.alwaysTemplate)
	}
}


// MARK: - Layout
extension StatusView
{

	func layoutBackgroundView()
	{
		addSubview(backgroundView)
		backgroundView.snp.makeConstraints
		{ make in
			make.edges.equalToSuperview()
		}
	}


	func layoutImageView()
	{
		imageView.tintColor = .appBlue

		backgroundView.contentView.addSubview(imageView)
		imageView.snp.makeConstraints
		{ make in
			make.size.equalTo(16)
			make.top.bottom.left.equalToSuperview().inset(4)
		}
	}


	func layoutTitleLabel()
	{
		titleLabel.textColor = .appBlue
		titleLabel.textAlignment = .left
		titleLabel.font = .systemFont(ofSize: 11, weight: .bold)
		titleLabel.numberOfLines = 1

		backgroundView.contentView.addSubview(titleLabel)
		titleLabel.snp.makeConstraints
		{ make in
			make.top.bottom.equalToSuperview()
			make.right.equalToSuperview().inset(8)
			make.left.equalTo(imageView.snp.right).offset(4)
		}
	}
}