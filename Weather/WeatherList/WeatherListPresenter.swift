//
//  WeatherListPresenter.swift
//  Weather
//
//  Created by Jacky Tjoa on 23/9/24.
//

protocol WeatherListPresenterDelegate {
    func presentCityList()
}

class WeatherListPresenter: WeatherListPresenterDelegate {
    weak var output: WeatherListViewDelegate?
    
    func presentCityList() {
        output?.displayCityList()
    }
}
