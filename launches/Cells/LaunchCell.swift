//
// Created by David Herzina on 2019-08-12.
// Copyright (c) 2019 David Herzina. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher


class LaunchCell: UITableViewCell
{
	var launch: Launch?
	{
		didSet
		{
			update()
		}
	}

	let cardView = UIView()

	let innerView = UIView()

	let statusView = StatusView()

	let photoView = UIImageView()

	let bottomView = GradientView()

	let titleLabel = UILabel()

	let subtitleLabel = UILabel()

	let dateLabel = UILabel()

	let placeholderImageView = UIImageView()


	override init(style: CellStyle, reuseIdentifier: String?)
	{
		super.init(style: style, reuseIdentifier: reuseIdentifier)
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
		selectionStyle = .none

		layoutCardView()
		layoutInnerView()
		layoutPhotoView()
		layoutPlaceholderImageView()
		layoutStatusView()
		layoutBottomView()
		layoutTitleLabel()
		layoutSubtitleLabel()
		layoutDateLabel()

		update()
	}


	fileprivate func update()
	{
		titleLabel.text = launch?.missionName
		subtitleLabel.text = launch?.rocketName
		statusView.isHidden = !(launch?.isSuccess ?? false)

		if let url = launch?.photos.first {
			placeholderImageView.isHidden = true
			photoView.image = nil
			photoView.isHidden = false
			photoView.kf.setImage(with: url, options: [.transition(.fade(1))])
		} else {
			placeholderImageView.isHidden = false
			placeholderImageView.image = launch?.rocketImage
			photoView.image = nil
			photoView.isHidden = true
		}

		if let date = launch?.date {

			let string = NSMutableAttributedString()

			let style = NSMutableParagraphStyle()
			style.lineSpacing = 4
			style.alignment = .right

			let dateFormatter = DateFormatter()
			dateFormatter.dateFormat = "MMM d, yyyy"
			string.append(NSAttributedString(string: dateFormatter.string(from: date), attributes: [
				.font: UIFont.systemFont(ofSize: 14, weight: .bold),
				.paragraphStyle: style
			]))

			let timeFormatter = DateFormatter()
			timeFormatter.dateFormat = "HH:mm"
			string.append(NSAttributedString(string: "\n\(timeFormatter.string(from: date))", attributes: [
				.font: UIFont.systemFont(ofSize: 14, weight: .regular),
				.paragraphStyle: style
			]))

			dateLabel.attributedText = string
		} else {
			dateLabel.attributedText = nil
		}
	}
}

// MARK: - Layout
extension LaunchCell
{

	func layoutCardView()
	{
		cardView.backgroundColor = .appBlackCard

		cardView.layer.borderWidth = 2
		cardView.layer.borderColor = UIColor.appDarker.cgColor
		cardView.layer.cornerRadius = 12
		cardView.layer.shadowColor = UIColor(red: 0 / 255, green: 0 / 255, blue: 0 / 255, alpha: 0.644).cgColor
		cardView.layer.shadowOpacity = 1
		cardView.layer.shadowOffset = .zero
		cardView.layer.shadowRadius = 16 / 2
		cardView.layer.shadowPath = nil

		addSubview(cardView)
		cardView.snp.makeConstraints
		{ make in
			make.left.right.equalToSuperview().inset(16)
			make.top.equalToSuperview().inset(10)
			make.bottom.equalToSuperview()
			make.height.equalTo(220)
		}
	}


	func layoutInnerView()
	{
		innerView.backgroundColor = .clear
		innerView.clipsToBounds = true
		innerView.layer.cornerRadius = 12

		cardView.addSubview(innerView)
		innerView.snp.makeConstraints
		{ make in
			make.edges.equalToSuperview()
		}
	}


	func layoutStatusView()
	{
		statusView.icon = UIImage(named: "icCheck")
		statusView.title = NSLocalizedString("launch.successLaunch", comment: "")

		cardView.addSubview(statusView)
		statusView.snp.makeConstraints
		{ make in
			make.top.left.equalToSuperview().offset(16)
		}
	}


	func layoutPhotoView()
	{
		photoView.contentMode = .scaleAspectFill
		photoView.layer.cornerRadius = 12
		photoView.clipsToBounds = true

		innerView.addSubview(photoView)
		photoView.snp.makeConstraints
		{ make in
			make.edges.equalToSuperview()
		}
	}


	/**
	 *
	 */
	func layoutPlaceholderImageView()
	{
		placeholderImageView.contentMode = .top
		placeholderImageView.transform = CGAffineTransform.identity.rotated(by: -10 * (.pi / 180))

		placeholderImageView.layer.shadowColor = UIColor(red: 0 / 255, green: 0 / 255, blue: 0 / 255, alpha: 0.5).cgColor
		placeholderImageView.layer.shadowOpacity = 1
		placeholderImageView.layer.shadowOffset = .zero
		placeholderImageView.layer.shadowRadius = 8 / 2
		placeholderImageView.layer.shadowPath = nil

		innerView.addSubview(placeholderImageView)
		placeholderImageView.snp.makeConstraints
		{ make in
			make.width.equalTo(116)
			make.top.equalToSuperview()
			make.centerX.equalToSuperview()
			make.bottom.equalToSuperview()
		}
	}


	func layoutBottomView()
	{
		bottomView.backgroundColor = .clear
		bottomView.gradient.colors = [
			UIColor.black.withAlphaComponent(0).cgColor,
			UIColor.black.withAlphaComponent(0.8).cgColor
		]

		innerView.addSubview(bottomView)
		bottomView.snp.makeConstraints
		{ make in
			make.left.right.bottom.equalToSuperview()
			make.height.equalTo(120)
		}
	}


	func layoutTitleLabel()
	{
		titleLabel.textAlignment = .left
		titleLabel.textColor = .appTextPrimary
		titleLabel.font = .systemFont(ofSize: 20, weight: .heavy)
		titleLabel.numberOfLines = 1

		titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
		titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

		bottomView.addSubview(titleLabel)
		titleLabel.snp.makeConstraints
		{ make in
			make.left.bottom.equalToSuperview().inset(16)
		}
	}


	func layoutSubtitleLabel()
	{
		subtitleLabel.textAlignment = .left
		subtitleLabel.textColor = .appTextSecondary
		subtitleLabel.font = .systemFont(ofSize: 14, weight: .semibold)
		subtitleLabel.numberOfLines = 1

		subtitleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
		subtitleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

		bottomView.addSubview(subtitleLabel)
		subtitleLabel.snp.makeConstraints
		{ make in
			make.bottom.equalTo(titleLabel.snp.top).offset(-2)
			make.left.equalToSuperview().offset(16)
		}
	}


	func layoutDateLabel()
	{
		dateLabel.textAlignment = .right
		dateLabel.textColor = .appTextSecondary
		dateLabel.numberOfLines = 2

		dateLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
		dateLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)

		bottomView.addSubview(dateLabel)
		dateLabel.snp.makeConstraints
		{ make in
			make.right.bottom.equalToSuperview().inset(16)
			make.left.equalTo(titleLabel.snp.right).offset(16)
			make.left.equalTo(subtitleLabel.snp.right).offset(16)
		}
	}
}