//
//  LastViewedCity.swift
//  Weather
//
//  Created by Jacky Tjoa on 26/9/24.
//

import Foundation

struct LastViewedCity: Codable {
    let key: String
    let city: String
    let country: String
    let latitude: String
    let longitude: String
    let dateViewed: Date
}
