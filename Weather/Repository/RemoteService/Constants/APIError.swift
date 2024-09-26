//
//  APIError.swift
//  Weather
//
//  Created by Jacky Tjoa on 25/9/24.
//

import Foundation

struct APIError {
    static let kDomain = "WeatherAPIError"
    static let dataError = NSError(domain: kDomain, code: 1001, userInfo: ["message": "no data available"])
}
