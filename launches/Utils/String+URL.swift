//
// Created by David Herzina on 2019-08-12.
// Copyright (c) 2019 David Herzina. All rights reserved.
//

import Foundation


extension String
{
	var urlEscaped: String
	{
		return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
	}

	var utf8Encoded: Data
	{
		return data(using: .utf8)!
	}
}