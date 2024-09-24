//
//  WeatherListInteractor.swift
//  Weather
//
//  Created by Jacky Tjoa on 23/9/24.
//

protocol WeatherListInteractorDelegate {
    func getCityList(searchString: String)
}

class WeatherListInteractor: WeatherListInteractorDelegate {
    var service: WeatherServiceProtocol?
    var output: WeatherListPresenterDelegate?
    
    func getCityList(searchString: String) {
        
    }
}
