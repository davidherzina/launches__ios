//
// Created by David Herzina on 2019-08-01.
// Copyright (c) 2019 David Herzina. All rights reserved.
//

import UIKit
import SnapKit
import Moya
import SwiftyJSON
import SwiftyUserDefaults


class LaunchListController: Controller
{
	var launches: [Launch] = []

	var sortType: LaunchSortType = .date

	var sortOrder: LaunchSortOrder = .descending

	let logoView = UIImageView()

	let titleLabel = UILabel()

	let buttonSort = ButtonIcon(style: .normal)

	let lineView = UIView()

	let tableView = UITableView()

	let refreshControl = UIRefreshControl()

	let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)

	let searchController = UISearchController(searchResultsController: nil)

	var searchResults: [Launch] = []


	override func viewDidLoad()
	{
		super.viewDidLoad()

		// Layout
		layoutLogo()
		layoutTitle()
		layoutButtonSort()
		layoutTableView()
		layoutLineView()
		layoutSearch()

		// Default Sort
		if let sortTypeString = Defaults[.sortType],
		   let sortOrderString = Defaults[.sortOrder] {
			self.sortType = LaunchSortType(rawValue: sortTypeString) ?? .date
			self.sortOrder = LaunchSortOrder(rawValue: sortOrderString) ?? .descending
		}

		// Data
		loadData(isFirstLoad: true)
	}


	override func viewWillAppear(_ animated: Bool)
	{
		super.viewWillAppear(animated)
		scrollViewDidScroll(tableView)
	}


	@objc
	func presentSort()
	{
		let controller = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

		controller.addAction(UIAlertAction(title: NSLocalizedString("list.sort.date.desc", comment: ""), style: .default)
		{ action in
			self.changeSort(type: .date, order: .descending)
		})

		controller.addAction(UIAlertAction(title: NSLocalizedString("list.sort.date.asc", comment: ""), style: .default)
		{ action in
			self.changeSort(type: .date, order: .ascending)
		})

		controller.addAction(UIAlertAction(title: NSLocalizedString("list.sort.rocket.asc", comment: ""), style: .default)
		{ action in
			self.changeSort(type: .rocketId, order: .ascending)
		})

		controller.addAction(UIAlertAction(title: NSLocalizedString("list.sort.cancel", comment: ""), style: .cancel))

		present(controller, animated: true)
	}


	func changeSort(type: LaunchSortType, order: LaunchSortOrder)
	{
		self.sortOrder = order
		self.sortType = type

		Defaults[.sortType] = self.sortType.rawValue
		Defaults[.sortOrder] = self.sortOrder.rawValue

		self.loadData(isFirstLoad: true)
	}


	@objc
	func loadData(isFirstLoad: Bool = false)
	{
		if isFirstLoad {
			launches = []
			tableView.reloadData()
			activityIndicator.startAnimating()
		}

		searchController.searchBar.isHidden = true
		searchController.searchBar.isUserInteractionEnabled = false

		let completion = {
			self.tableView.reloadData()
			self.refreshControl.endRefreshing()
			self.activityIndicator.stopAnimating()
			self.searchController.searchBar.isHidden = false
			self.searchController.searchBar.isUserInteractionEnabled = true

			if self.launches.count > 0 {
				self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
			}
		}

		let provider = MoyaProvider<ApiService>()
		provider.request(.pastLaunches(sort: sortType, order: sortOrder))
		{ result in

			guard let data = try? result.value?.mapJSON() as Any else {
				completion()
				return
			}

			self.launches = []
			if let array = JSON(data).array {
				for json in array {
					self.launches.append(Launch(json: json))
				}
			}

			completion()
		}
	}
}


// MARK: - Layout
extension LaunchListController
{

	func layoutLogo()
	{
		logoView.image = UIImage(named: "icLogo")?.withRenderingMode(.alwaysOriginal)

		view.addSubview(logoView)
		logoView.snp.makeConstraints
		{ make in
			make.width.equalTo(81)
			make.height.equalTo(10)
			make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
			make.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(16)
		}
	}


	func layoutTitle()
	{
		titleLabel.text = NSLocalizedString("list.title", comment: "").uppercased()
		titleLabel.textAlignment = .left
		titleLabel.textColor = .appTextPrimary
		titleLabel.font = .systemFont(ofSize: 24, weight: .heavy)
		titleLabel.numberOfLines = 1

		view.addSubview(titleLabel)
		titleLabel.snp.makeConstraints
		{ make in
			make.top.equalTo(logoView.snp.bottom).offset(2)
			make.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(16)
			make.height.equalTo(28)
		}
	}


	func layoutButtonSort()
	{
		buttonSort.image = UIImage(named: "icSort")
		buttonSort.addTarget(self, action: #selector(presentSort), for: .touchUpInside)

		view.addSubview(buttonSort)
		buttonSort.snp.makeConstraints
		{ make in
			make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
			make.right.equalTo(view.safeAreaLayoutGuide.snp.right).offset(-16)
			make.left.equalTo(titleLabel.snp.right).offset(-16)
		}
	}


	func layoutTableView()
	{
		tableView.separatorStyle = .none
		tableView.tableFooterView = UIView()
		tableView.backgroundColor = .clear
		tableView.clipsToBounds = true
		tableView.contentInset = UIEdgeInsets(
				top: 0,
				left: 0,
				bottom: view.safeAreaInsets.bottom,
				right: 0
		)
		tableView.scrollIndicatorInsets = UIEdgeInsets(
				top: 0,
				left: 0,
				bottom: view.safeAreaInsets.bottom,
				right: 0
		)

		tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNormalMagnitude))
		tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNormalMagnitude))

		tableView.delegate = self
		tableView.dataSource = self

		view.addSubview(tableView)
		tableView.snp.makeConstraints
		{ make in
			make.top.equalTo(buttonSort.snp.bottom).offset(16)
			make.left.bottom.right.equalToSuperview()
			make.centerX.equalToSuperview()
		}

		tableView.register(LaunchCell.self, forCellReuseIdentifier: "cell")

		refreshControl.tintColor = .appTextPrimary
		refreshControl.addTarget(self, action: #selector(loadData), for: .valueChanged)

		tableView.refreshControl = refreshControl

		activityIndicator.color = .appTextSecondary
		activityIndicator.hidesWhenStopped = true
		activityIndicator.center = view.center

		view.addSubview(activityIndicator)
		view.bringSubviewToFront(activityIndicator)
	}


	func layoutLineView()
	{
		lineView.backgroundColor = .appDarker

		view.addSubview(lineView)
		lineView.snp.makeConstraints
		{ make in
			make.height.equalTo(1)
			make.top.equalTo(tableView.snp.top)
			make.left.right.equalToSuperview()
		}
	}


	func layoutSearch()
	{
		searchController.searchResultsUpdater = self
		searchController.dimsBackgroundDuringPresentation = false
		searchController.hidesNavigationBarDuringPresentation = false
		searchController.searchBar.sizeToFit()
		searchController.searchBar.searchBarStyle = .prominent
		searchController.searchBar.barStyle = .black
		searchController.searchBar.tintColor = .appTextPrimary

		tableView.tableHeaderView = searchController.searchBar

		let view = UIView()
		view.backgroundColor = .clear

		tableView.backgroundView = view
	}
}


// MARK: - UITableViewDataSource
extension LaunchListController: UITableViewDataSource
{

	public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
	{
		return searchController.isActive ? searchResults.count : launches.count
	}


	public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
	{
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? LaunchCell else {
			return LaunchCell(style: .default, reuseIdentifier: "cell")
		}

		cell.launch = searchController.isActive ? searchResults[indexPath.row] : launches[indexPath.row]

		return cell
	}
}


// MARK: - UITableViewDelegate
extension LaunchListController: UITableViewDelegate
{
	public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
	{
		tableView.deselectRow(at: indexPath, animated: true)

		let launch = searchController.isActive ? searchResults[indexPath.row] : launches[indexPath.row]
		searchController.isActive = false

		let controller = LaunchDetailController()
		controller.launch = launch

		navigationController?.pushViewController(controller, animated: true)
	}
}


// MARK: - UIScrollViewDelegate
extension LaunchListController: UIScrollViewDelegate
{
	public func scrollViewDidScroll(_ scrollView: UIScrollView)
	{
		let offset = scrollView.contentOffset.y
		lineView.isHidden = !(offset > 60)
	}
}


// MARK: - UISearchResultsUpdating
extension LaunchListController: UISearchResultsUpdating
{
	public func updateSearchResults(for searchController: UISearchController)
	{
		searchResults.removeAll(keepingCapacity: false)
		tableView.reloadData()

		guard let query = searchController.searchBar.text?.lowercased(), query.count > 0 else {
			return
		}

		searchResults = launches.filter({
			$0.missionName.lowercased().contains(query) || $0.rocketName.lowercased().contains(query)
		})

		tableView.reloadData()
	}
}