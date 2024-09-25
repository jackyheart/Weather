//
//  WeatherService.swift
//  Weather
//
//  Created by Jacky Tjoa on 23/9/24.
//

import Foundation

protocol WeatherServiceDelegate {
    func fetchCityList(query: String, success: @escaping (SearchResponse?) -> Void, 
                       failure: @escaping (Error?) -> Void)
    func fetchWeatherData(query: String, success: @escaping (WeatherData?) -> Void, 
                          failure: @escaping (Error?) -> Void)
}

class WeatherService: WeatherServiceDelegate {
    var httpClient: HTTPClientProtocol = HTTPClient()
    
    func fetchCityList(query: String, success: @escaping (SearchResponse?) -> Void, 
                       failure: @escaping (Error?) -> Void) {
        let urlString = WeatherAPI.search + "?key=" + WeatherAPI.key + "&q=" + query + "&format=json"
        httpClient.fetchData(urlString: urlString,
                             completion: { data, error in
            guard let data = data else {
                failure(APIError.dataError)
                return
            }
            do {
                let response = try JSONDecoder().decode(SearchResponse.self, from: data)
                success(response)
            } catch let error {
                failure(error)
            }
        })
    }
    
    func fetchWeatherData(query: String, success: @escaping (WeatherData?) -> Void, 
                          failure: @escaping (Error?) -> Void) {
        httpClient.fetchData(urlString: WeatherAPI.weather + query,
                             completion: { data, error in
            guard let data = data else {
                failure(APIError.dataError)
                return
            }
            do {
                let response = try JSONDecoder().decode(WeatherResponse.self, from: data)
                success(response.data)
            } catch let error {
                failure(error)
            }
        })
    }
}
