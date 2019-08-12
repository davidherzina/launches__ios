//
// Created by David Herzina on 2019-08-01.
// Copyright (c) 2019 David Herzina. All rights reserved.
//

import UIKit
import SnapKit


enum ButtonStyle
{
	case normal
	case blue
}

// MARK: - Button
class Button: UIButton
{

	let style: ButtonStyle


	init(style: ButtonStyle)
	{
		self.style = style
		super.init(frame: .zero)
		create()
	}


	required init?(coder aDecoder: NSCoder)
	{
		style = .normal
		super.init(coder: aDecoder)
		create()
	}


	fileprivate func create()
	{
		layer.cornerRadius = 20
		clipsToBounds = true

		snp.makeConstraints
		{ make in
			make.height.equalTo(40)
		}

		switch style {
		case .normal:
			backgroundColor = .appBlackTransparent
			tintColor = .appTextPrimary
			break

		case .blue:
			backgroundColor = .appBlueTransparent
			tintColor = .appBlue
			break
		}
	}
}

// MARK: - ButtonIcon
class ButtonIcon: Button
{
	var image: UIImage?
	{
		didSet
		{
			update()
		}
	}


	fileprivate override func create()
	{
		super.create()

		snp.remakeConstraints
		{ make in
			make.size.equalTo(40)
		}

		update()
	}


	fileprivate func update()
	{
		let templateImage = image?.withRenderingMode(.alwaysTemplate)

		setImage(templateImage, for: .normal)
		setImage(templateImage, for: .highlighted)
		setImage(templateImage, for: .selected)
		setImage(templateImage, for: .disabled)
		setImage(templateImage, for: .focused)
	}
}


class ButtonText: Button
{
	var image: UIImage?
	{
		didSet
		{
			update()
		}
	}

	var title: String?
	{
		didSet
		{
			update()
		}
	}


	fileprivate override func create()
	{
		super.create()

		snp.remakeConstraints
		{ make in
			make.height.equalTo(36)
		}

		switch style {
		case .normal:
			setTitleColor(.appTextPrimary, for: .normal)
			setTitleColor(.appTextPrimary, for: .highlighted)
			setTitleColor(.appTextPrimary, for: .focused)
			setTitleColor(.appTextPrimary, for: .disabled)
			break

		case .blue:
			setTitleColor(.appBlue, for: .normal)
			setTitleColor(.appBlue, for: .highlighted)
			setTitleColor(.appBlue, for: .focused)
			setTitleColor(.appBlue, for: .disabled)
			break
		}

		layer.cornerRadius = 18
		titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)

		imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
		contentEdgeInsets = UIEdgeInsets(top: 0, left: 11, bottom: 0, right: 12)

		update()
	}


	fileprivate func update()
	{
		let templateImage = image?.withRenderingMode(.alwaysTemplate)

		setImage(templateImage, for: .normal)
		setImage(templateImage, for: .highlighted)
		setImage(templateImage, for: .selected)
		setImage(templateImage, for: .disabled)
		setImage(templateImage, for: .focused)

		setTitle(title, for: .normal)
		setTitle(title, for: .highlighted)
		setTitle(title, for: .focused)
		setTitle(title, for: .disabled)
	}
}