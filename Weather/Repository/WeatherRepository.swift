//
//  WeatherRepository.swift
//  Weather
//
//  Created by Jacky Tjoa on 24/9/24.
//

protocol WeatherRepositoryDelegate {
    func retrieveLastSearchedCities(limit: Int)
    func fetchCityList(searchString: String)
    func fetchWeather(city: String)
}

class WeatherRepository: WeatherRepositoryDelegate {
    var remoteSource: WeatherServiceDelegate?
    
    func retrieveLastSearchedCities(limit: Int) {
    }
    
    func fetchCityList(searchString: String) {
    }
    
    func fetchWeather(city: String) {
        remoteSource?.fetchWeatherData(query: city, completion: { data in
        })
    }
}
