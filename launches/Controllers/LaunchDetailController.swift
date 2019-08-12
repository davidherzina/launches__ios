//
// Created by David Herzina on 2019-08-12.
// Copyright (c) 2019 David Herzina. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher
import SafariServices


class LaunchDetailController: Controller
{

	var launch: Launch!

	let scrollView = UIScrollView()

	let imageView = UIImageView()

	let overlayView = GradientView()

	let topView = UIView()

	let buttonBack = ButtonIcon(style: .normal)

	let launchLabel = UILabel()

	let missionNameLabel = UILabel()

	let cardView = UIView()

	let cardInnerView = UIView()

	let rocketView = UIImageView()

	let rocketLabel = UILabel()

	let buttonPlay = ButtonText(style: .blue)

	let launchSiteLabel = UILabel()

	let launchDateLabel = UILabel()

	let detailsLabel = UILabel()


	override func viewDidLoad()
	{
		super.viewDidLoad()

		// Layout
		layoutScrollView()
		layoutImageView()
		layoutOverlayView()
		layoutButtonBack()
		layoutLaunchLabel()
		layoutMissionNameLabel()
		layoutCardView()
		layoutRocketView()
		layoutRocketLabel()
		layoutButtonPlay()
		layoutLaunchInfo()
		layoutDetailsLabel()
	}


	override func viewWillAppear(_ animated: Bool)
	{
		super.viewWillAppear(animated)
		scrollViewDidScroll(scrollView)
	}


	@objc
	func presentBack()
	{
		navigationController?.popViewController(animated: true)
	}


	@objc
	func presentPlay()
	{
		guard let url = launch.videoUrl else {
			return
		}

		let controller = SFSafariViewController(url: url)
		present(controller, animated: true)
	}
}

// MARK: - Layout
extension LaunchDetailController
{

	func layoutScrollView()
	{
		scrollView.backgroundColor = .clear
		scrollView.delegate = self
		scrollView.alwaysBounceHorizontal = false
		scrollView.alwaysBounceVertical = true
		scrollView.showsHorizontalScrollIndicator = false
		scrollView.contentInsetAdjustmentBehavior = .never
		scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: view.safeAreaInsets.bottom, right: 0)
		scrollView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: view.safeAreaInsets.bottom, right: 0)

		view.addSubview(scrollView)
		scrollView.snp.makeConstraints
		{ make in
			make.edges.equalToSuperview()
		}
	}


	func layoutImageView()
	{
		imageView.kf.setImage(with: launch?.photos.first)
		imageView.contentMode = .scaleAspectFill
		imageView.clipsToBounds = true

		scrollView.addSubview(imageView)
		imageView.snp.makeConstraints
		{ make in
			make.top.width.left.right.equalToSuperview()
			make.height.equalTo(294)
		}
	}


	func layoutOverlayView()
	{
		overlayView.backgroundColor = .clear
		overlayView.gradient.colors = [
			UIColor.black.withAlphaComponent(1).cgColor,
			UIColor.black.withAlphaComponent(0.6).cgColor,
			UIColor.black.withAlphaComponent(0.5).cgColor
		]
		overlayView.isHidden = launch?.photos.first == nil

		scrollView.addSubview(overlayView)
		overlayView.snp.makeConstraints
		{ make in
			make.top.width.left.right.equalToSuperview()
			make.height.equalTo(294)
		}

		let bounceView = UIView()
		bounceView.backgroundColor = .black
		bounceView.isHidden = launch?.photos.first == nil

		scrollView.addSubview(bounceView)
		bounceView.snp.makeConstraints
		{ make in
			make.left.right.width.equalToSuperview()
			make.height.equalTo(2000)
			make.top.equalToSuperview().offset(-2000)
		}
	}


	func layoutButtonBack()
	{
		buttonBack.image = UIImage(named: "icBack")
		buttonBack.addTarget(self, action: #selector(presentBack), for: .touchUpInside)

		view.addSubview(buttonBack)
		buttonBack.snp.makeConstraints
		{ make in
			make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
			make.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(16)
		}

		topView.backgroundColor = .appDark
		topView.layer.shadowColor = UIColor(red: 0 / 255, green: 0 / 255, blue: 0 / 255, alpha: 0.5).cgColor
		topView.layer.shadowOpacity = 1
		topView.layer.shadowOffset = .zero
		topView.layer.shadowRadius = 16 / 2
		topView.layer.shadowPath = nil

		view.addSubview(topView)
		topView.snp.makeConstraints
		{ make in
			make.top.left.right.width.equalToSuperview()
			make.height.equalTo(72 + (UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0))
		}

		view.bringSubviewToFront(buttonBack)

		let label = UILabel()
		label.text = launch.missionName
		label.textAlignment = .center
		label.textColor = .appTextPrimary
		label.font = .systemFont(ofSize: 20, weight: .bold)
		label.numberOfLines = 1

		topView.addSubview(label)
		label.snp.makeConstraints
		{ make in
			make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
			make.bottom.equalToSuperview()
			make.left.right.equalToSuperview().inset(72)
		}
	}


	func layoutLaunchLabel()
	{
		launchLabel.text = NSLocalizedString("detail.launch", comment: "")
		launchLabel.textColor = .appTextSecondary
		launchLabel.textAlignment = .left
		launchLabel.font = .systemFont(ofSize: 24, weight: .semibold)
		launchLabel.numberOfLines = 1

		scrollView.addSubview(launchLabel)
		launchLabel.snp.makeConstraints
		{ make in
			make.top.equalToSuperview().offset(130)
			make.left.right.width.equalToSuperview().inset(16)
		}
	}


	func layoutMissionNameLabel()
	{
		missionNameLabel.text = launch.missionName
		missionNameLabel.textAlignment = .left
		missionNameLabel.textColor = .appTextPrimary
		missionNameLabel.font = .systemFont(ofSize: 32, weight: .heavy)
		missionNameLabel.numberOfLines = 1

		scrollView.addSubview(missionNameLabel)
		missionNameLabel.snp.makeConstraints
		{ make in
			make.left.right.width.equalToSuperview().inset(16)
			make.top.equalTo(launchLabel.snp.bottom)
		}
	}


	func layoutCardView()
	{
		cardView.backgroundColor = .appDark
		cardView.layer.cornerRadius = 16
		cardView.layer.shadowColor = UIColor(red: 0 / 255, green: 0 / 255, blue: 0 / 255, alpha: 0.5).cgColor
		cardView.layer.shadowOpacity = 1
		cardView.layer.shadowOffset = .zero
		cardView.layer.shadowRadius = 16 / 2
		cardView.layer.shadowPath = nil

		scrollView.addSubview(cardView)
		cardView.snp.makeConstraints
		{ make in
			make.top.equalTo(missionNameLabel.snp.bottom).offset(12)
			make.left.right.width.equalToSuperview().inset(16)
			make.height.equalTo(425)
		}

		let label = UILabel()
		label.text = NSLocalizedString("detail.core", comment: "").uppercased()
		label.textColor = .appDarkGrey
		label.textAlignment = .left
		label.font = .systemFont(ofSize: 12, weight: .bold)
		label.numberOfLines = 1

		cardView.addSubview(label)
		label.snp.makeConstraints
		{ make in
			make.top.left.equalToSuperview().offset(16)
		}

		cardInnerView.clipsToBounds = true
		cardInnerView.layer.cornerRadius = 16

		cardView.addSubview(cardInnerView)
		cardInnerView.snp.makeConstraints
		{ make in
			make.edges.equalToSuperview()
		}
	}


	func layoutRocketView()
	{
		rocketView.contentMode = .top
		rocketView.transform = CGAffineTransform.identity.rotated(by: -10 * (.pi / 180))
		rocketView.image = launch.rocketImage

		rocketView.layer.shadowColor = UIColor(red: 0 / 255, green: 0 / 255, blue: 0 / 255, alpha: 0.5).cgColor
		rocketView.layer.shadowOpacity = 1
		rocketView.layer.shadowOffset = .zero
		rocketView.layer.shadowRadius = 8 / 2
		rocketView.layer.shadowPath = nil

		cardInnerView.addSubview(rocketView)
		rocketView.snp.makeConstraints
		{ make in
			make.width.equalTo(116)
			make.top.bottom.equalToSuperview()
			make.right.equalToSuperview().offset(-16)
		}
	}


	func layoutRocketLabel()
	{
		let label = UILabel()
		label.text = NSLocalizedString("detail.rocket", comment: "")
		label.textAlignment = .left
		label.textColor = .appTextSecondary
		label.font = .systemFont(ofSize: 16, weight: .bold)
		label.numberOfLines = 1

		cardInnerView.addSubview(label)
		label.snp.makeConstraints
		{ make in
			make.top.equalToSuperview().offset(54)
			make.left.equalToSuperview().offset(16)
		}

		rocketLabel.text = launch.rocketName
		rocketLabel.textAlignment = .left
		rocketLabel.textColor = .appTextPrimary
		rocketLabel.font = .systemFont(ofSize: 32, weight: .bold)
		rocketLabel.numberOfLines = 0

		cardInnerView.addSubview(rocketLabel)
		rocketLabel.snp.makeConstraints
		{ make in
			make.top.equalTo(label.snp.bottom).offset(4)
			make.left.equalToSuperview().offset(16)
			make.right.equalTo(rocketView.snp.left).offset(-16)
		}
	}


	func layoutButtonPlay()
	{
		buttonPlay.title = NSLocalizedString("detail.play", comment: "")
		buttonPlay.image = UIImage(named: "icPlay")
		buttonPlay.addTarget(self, action: #selector(presentPlay), for: .touchUpInside)
		buttonPlay.isHidden = launch.videoUrl == nil

		cardInnerView.addSubview(buttonPlay)
		buttonPlay.snp.makeConstraints
		{ make in
			make.top.equalTo(rocketLabel.snp.bottom).offset(24)
			make.left.equalToSuperview().offset(16)
		}
	}


	func layoutLaunchInfo()
	{
		launchSiteLabel.text = launch.launchSite
		launchSiteLabel.textAlignment = .left
		launchSiteLabel.textColor = .appTextPrimary
		launchSiteLabel.font = .systemFont(ofSize: 16, weight: .bold)
		launchSiteLabel.numberOfLines = 3

		cardInnerView.addSubview(launchSiteLabel)
		launchSiteLabel.snp.makeConstraints
		{ make in
			make.bottom.left.equalToSuperview().inset(16)
			make.right.equalTo(rocketView.snp.left).offset(-16)
		}

		let launchSiteSubtitleLabel = UILabel()
		launchSiteSubtitleLabel.text = NSLocalizedString("detail.site", comment: "")
		launchSiteSubtitleLabel.textColor = .appTextSecondary
		launchSiteSubtitleLabel.textAlignment = .left
		launchSiteSubtitleLabel.font = .systemFont(ofSize: 12, weight: .bold)
		launchSiteSubtitleLabel.numberOfLines = 1

		cardInnerView.addSubview(launchSiteSubtitleLabel)
		launchSiteSubtitleLabel.snp.makeConstraints
		{ make in
			make.left.equalToSuperview().offset(16)
			make.bottom.equalTo(launchSiteLabel.snp.top).offset(-2)
		}

		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "MMM d, yyyy"

		launchDateLabel.text = dateFormatter.string(from: launch.date)
		launchDateLabel.textAlignment = .left
		launchDateLabel.textColor = .appTextPrimary
		launchDateLabel.font = .systemFont(ofSize: 16, weight: .bold)
		launchDateLabel.numberOfLines = 1

		cardInnerView.addSubview(launchDateLabel)
		launchDateLabel.snp.makeConstraints
		{ make in
			make.bottom.equalTo(launchSiteSubtitleLabel.snp.top).offset(-24)
			make.left.equalToSuperview().offset(16)
			make.right.equalTo(rocketView.snp.left).offset(-16)
		}

		let launchDateSubtitleLabel = UILabel()
		launchDateSubtitleLabel.text = NSLocalizedString("detail.date", comment: "")
		launchDateSubtitleLabel.textColor = .appTextSecondary
		launchDateSubtitleLabel.textAlignment = .left
		launchDateSubtitleLabel.font = .systemFont(ofSize: 12, weight: .bold)
		launchDateSubtitleLabel.numberOfLines = 1

		cardInnerView.addSubview(launchDateSubtitleLabel)
		launchDateSubtitleLabel.snp.makeConstraints
		{ make in
			make.left.equalToSuperview().offset(16)
			make.bottom.equalTo(launchDateLabel.snp.top).offset(-2)
		}
	}


	func layoutDetailsLabel()
	{
		let string = NSMutableAttributedString()

		let style = NSMutableParagraphStyle()
		style.lineSpacing = 4
		style.alignment = .right

		string.append(NSAttributedString(string: launch.details ?? "", attributes: [
			.paragraphStyle: style
		]))

		detailsLabel.attributedText = string
		detailsLabel.textColor = .appTextSecondary
		detailsLabel.textAlignment = .left
		detailsLabel.font = .systemFont(ofSize: 12, weight: .regular)
		detailsLabel.numberOfLines = 0

		scrollView.addSubview(detailsLabel)
		detailsLabel.snp.makeConstraints
		{ make in
			make.top.equalTo(cardView.snp.bottom).offset(24)
			make.left.right.width.equalToSuperview().inset(16)
			make.bottom.equalToSuperview().offset(-64)
		}
	}
}


// MARK: - UIScrollViewDelegate
extension LaunchDetailController: UIScrollViewDelegate
{
	public func scrollViewDidScroll(_ scrollView: UIScrollView)
	{
		let y = scrollView.contentOffset.y
		topView.isHidden = y < 20
	}
}