//
//  WeatherResponse.swift
//  Weather
//
//  Created by Jacky Tjoa on 23/9/24.
//

struct WeatherResponse: Codable {
    let data: WeatherData
}

struct WeatherData: Codable {
    let request: WeatherRequest
    let currentCondition: [WeatherCondition]
    
    enum CodingKeys: String, CodingKey {
        case request
        case currentCondition = "current_condition"
    }
}

struct WeatherRequest: Codable {
    let type: String
    let query: String
}

struct WeatherCondition: Codable {
    let weatherIconUrl: [ValueList]
    let weatherDesc: [ValueList]
}
