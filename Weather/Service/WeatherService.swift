//
//  WeatherService.swift
//  Weather
//
//  Created by Jacky Tjoa on 23/9/24.
//

import Foundation

protocol WeatherServiceDelegate {
    func fetchData<T: Decodable>(query: String, 
                                 success: @escaping (T?) -> Void,
                                 failure: @escaping (Error?) -> Void)
}

class WeatherService: WeatherServiceDelegate {
    var httpClient: HTTPClientProtocol = HTTPClient()
    
    private func buildURL(withBaseURL baseURL: String, query: String) -> String {
        return baseURL + "?key=" + WeatherAPI.key + "&q=" + query + "&format=json"
    }
    
    func fetchData<T: Decodable>(query: String,
                                 success: @escaping (T?) -> Void,
                                 failure: @escaping (Error?) -> Void) {
        let urlString = buildURL(withBaseURL: WeatherAPI.search, query: query)
        httpClient.fetchData(urlString: urlString,
                             completion: { data, error in
            guard let data = data else {
                failure(APIError.dataError)
                return
            }
            do {
                let response = try JSONDecoder().decode(T.self, from: data)
                success(response)
            } catch let error {
                failure(error)
            }
        })
    }
}
