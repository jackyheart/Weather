//
//  WeatherRepository.swift
//  Weather
//
//  Created by Jacky Tjoa on 24/9/24.
//

protocol WeatherRepositoryDelegate {
    func storeViewedCity(data: ResultItem)
    func retrieveViewedCities(limit: Int, ordering: ItemOrdering) -> [ViewedItem]
    func fetchCityList(searchString: String,
                       success: @escaping (SearchResponse?) -> Void,
                       failure: @escaping (Error?) -> Void)
    func fetchWeather(city: String)
}

class WeatherRepository: WeatherRepositoryDelegate {
    var localSource: LocalStorageManagerDelegate? = LocalStorageManager()
    var remoteSource: RemoteServiceManagerDelegate? = RemoteServiceManager()
    
    func storeViewedCity(data: ResultItem) {
        localSource?.saveViewedItem(data: data)
    }
    
    func retrieveViewedCities(limit: Int, ordering: ItemOrdering) -> [ViewedItem] {
        return localSource?.retrieveViewedItems(limit: limit, ordering: ordering) ?? []
    }
    
    func fetchCityList(searchString: String, 
                       success: @escaping (SearchResponse?) -> Void, 
                       failure: @escaping (Error?) -> Void) {
        remoteSource?.fetchCityList(searchString: searchString, success: success, failure: failure)
    }
    
    func fetchWeather(city: String) {
    }
}
