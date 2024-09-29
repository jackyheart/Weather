//
//  APIError.swift
//  Weather
//
//  Created by Jacky Tjoa on 25/9/24.
//

import Foundation

struct APIError {
    static let kDomain = "WeatherAPIError"
    static let kMessageKey = "message"
    static let noData = NSError(domain: kDomain, code: 1001, userInfo: [kMessageKey: "no data available"])
    static let dataError = NSError(domain: kDomain, code: 1002, userInfo: [kMessageKey: "fetched data couldn't be read"])
}
