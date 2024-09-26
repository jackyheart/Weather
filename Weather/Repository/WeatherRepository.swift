//
//  WeatherRepository.swift
//  Weather
//
//  Created by Jacky Tjoa on 24/9/24.
//

protocol WeatherRepositoryDelegate {
    func retrieveLastVisitedCities(limit: Int)
    func fetchCityList(searchString: String, success: @escaping (SearchResponse?) -> Void, 
                       failure: @escaping (Error?) -> Void)
    func fetchWeather(city: String)
}

class WeatherRepository: WeatherRepositoryDelegate {
    var localSource: LocalStorageDelegate = LocalStorageManager()
    var remoteSource: WeatherServiceDelegate? = WeatherService()
    
    func retrieveLastVisitedCities(limit: Int) {
        localSource.retrieveViewedCities(limit: limit)
    }
    
    func fetchCityList(searchString: String, success: @escaping (SearchResponse?) -> Void, 
                       failure: @escaping (Error?) -> Void) {
        remoteSource?.fetchData(query: searchString, success: success, failure: failure)
    }
    
    func fetchWeather(city: String) {
    }
}
