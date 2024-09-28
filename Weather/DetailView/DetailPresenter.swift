//
//  DetailPresenter.swift
//  Weather
//
//  Created by Jacky Tjoa on 28/9/24.
//

protocol DetailPresenterDelegate {
    func presentWeatherResult(result: WeatherCondition?)
    func presentError(error: Error?)
}

class DetailPresenter: DetailPresenterDelegate {
    weak var view: DetailViewControllerDelegate?
    
    func presentWeatherResult(result: WeatherCondition?) {
        //TODO: convert to view model
    }
    
    func presentError(error: Error?) {
        
    }
}
