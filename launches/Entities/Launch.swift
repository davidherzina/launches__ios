//
// Created by David Herzina on 2019-08-12.
// Copyright (c) 2019 David Herzina. All rights reserved.
//

import Foundation
import SwiftyJSON


enum LaunchSortType: String
{
	case date = "launch_date_utc"
	case rocketId = "rocket_id"
}

enum LaunchSortOrder: String
{
	case ascending = "asc"
	case descending = "desc"
}

enum RocketType: String
{
	case falcon1 = "falcon1"
	case falconHeavy = "falconheavy"
	case falcon9 = "falcon9"
	case falconRocket = "bfr"
	case unknown = ""
}


struct Launch
{

	var isSuccess: Bool = false

	var photos: [URL] = []

	var date: Date = Date()

	var missionName: String = ""

	var rocketId: String = ""

	var rocketName: String = ""

	var rocketType: RocketType = .unknown

	var rocketImage: UIImage?
	{
		return UIImage(named: "icRocket__\(rocketType.rawValue)")?.withRenderingMode(.alwaysOriginal)
	}

	var launchSite: String = ""

	var details: String?

	var videoUrl: URL?


	init(json: JSON)
	{
		if let rawPhotos = json["links"]["flickr_images"].array {
			for rawPhoto in rawPhotos {
				if let url = rawPhoto.url {
					photos.append(url)
				}
			}
		}

		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
		formatter.timeZone = TimeZone(secondsFromGMT: 0)

		if let string = json["launch_date_utc"].string,
		   let date = formatter.date(from: string) {
			self.date = date
		}

		if let type = RocketType(rawValue: json["rocket"]["rocket_id"].stringValue) {
			rocketType = type
		}

		isSuccess = json["launch_success"].boolValue
		rocketId = json["rocket"]["rocket_id"].stringValue
		rocketName = json["rocket"]["rocket_name"].stringValue
		missionName = json["mission_name"].stringValue
		launchSite = json["launch_site"]["site_name_long"].stringValue
		details = json["details"].string
		videoUrl = json["links"]["video_link"].url
	}
}