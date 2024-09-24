//
//  WeatherService.swift
//  Weather
//
//  Created by Jacky Tjoa on 23/9/24.
//

import Foundation

protocol WeatherServiceDelegate {
    func fetchWeatherData(query: String, completion: @escaping (WeatherData?) -> Void)
}

class WeatherService: WeatherServiceDelegate {
    var httpClient: HTTPClientProtocol = HTTPClient()
    
    func fetchWeatherData(query: String, completion: @escaping (WeatherData?) -> Void) {
        httpClient.fetchData(urlString: WeatherAPI.weather + query,
                             completion: { data, error in
            guard let data = data else {
                //TODO: return failure block
                return
            }
            do {
                let response = try JSONDecoder().decode(WeatherResponse.self, from: data)
                completion(response.data)
            } catch let error {
                //TODO: return failure block
            }
        })
    }
}
