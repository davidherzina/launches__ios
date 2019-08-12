//
// Created by David Herzina on 2019-08-12.
// Copyright (c) 2019 David Herzina. All rights reserved.
//

import Foundation
import Moya


enum ApiService
{
	case pastLaunches(sort: LaunchSortType, order: LaunchSortOrder)
}

extension ApiService: TargetType
{

	var baseURL: URL
	{
		return URL(string: "https://api.spacexdata.com/v3/")!
	}

	var path: String
	{
		switch self {
		case .pastLaunches:
			return "launches/past"
		}
	}

	var method: Moya.Method
	{
		switch self {
		case .pastLaunches:
			return .get
		}
	}

	var task: Task
	{
		switch self {
		case .pastLaunches(let sort, let order):
			return .requestParameters(parameters: [
				"sort": sort.rawValue,
				"order": order.rawValue
			], encoding: URLEncoding.default)
		}
	}

	var sampleData: Data
	{
		return "{}".utf8Encoded
	}

	var headers: [String: String]?
	{
		return [
			"Content-type": "application/json"
		]
	}
}