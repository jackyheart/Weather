//
//  WeatherListPresenter.swift
//  Weather
//
//  Created by Jacky Tjoa on 23/9/24.
//

protocol WeatherListPresenterDelegate {
    func presentCityList()
    func presentError(error: Error?)
}

class WeatherListPresenter: WeatherListPresenterDelegate {
    weak var view: WeatherListViewDelegate?
    
    func presentCityList() {
        view?.displayCityList()
    }
    
    func presentError(error: Error?) {
        view?.displayErrorAlert(error: error)
    }
}
