//
//  RemoteServiceManager.swift
//  Weather
//
//  Created by Jacky Tjoa on 26/9/24.
//

protocol RemoteServiceManagerDelegate {
    func fetchCityList(searchString: String, 
                       success: @escaping (SearchResponse?) -> Void,
                       failure: @escaping (Error?) -> Void)
}

class RemoteServiceManager: RemoteServiceManagerDelegate {
    var service: RemoteServiceDelegate? = RemoteService()
    
    func fetchCityList(searchString: String, 
                       success: @escaping (SearchResponse?) -> Void,
                       failure: @escaping (Error?) -> Void) {
        let urlString = buildURL(api: .search, query: searchString)
        service?.fetchData(urlString: urlString, success: success, failure: failure)
    }
    
    private func buildURL(api: WeatherAPI, query: String) -> String {
        var baseURL = WeatherAPIConstant.baseURL
        switch api {
        case .search:
            baseURL.append(WeatherAPIEndpoint.search)
        case .weather:
            baseURL.append(WeatherAPIEndpoint.weather)
        }
        return baseURL + "?key=" + WeatherAPIConstant.key + "&q=" + query + "&format=json"
    }
}
