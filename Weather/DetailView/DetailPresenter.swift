//
//  DetailPresenter.swift
//  Weather
//
//  Created by Jacky Tjoa on 28/9/24.
//

protocol DetailPresenterDelegate {
    func presentWeatherResult(onDataItem dataItem: ResultItem?, result: WeatherCondition?)
    func presentError(error: Error?)
}

class DetailPresenter: DetailPresenterDelegate {
    weak var view: DetailViewControllerDelegate?
    
    func presentWeatherResult(onDataItem dataItem: ResultItem?, result: WeatherCondition?) {
        let viewModel = DetailViewModel(city: dataItem?.areaName.first?.value,
                                        country: dataItem?.country.first?.value,
                                        temperatureCelcius: result?.tempC,
                                        imageURLString: result?.weatherIconUrl.first?.value,
                                        weatherDescription: result?.weatherDesc.first?.value)
        view?.displayResult(result: viewModel)
    }
    
    func presentError(error: Error?) {
        
    }
}
