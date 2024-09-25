//
//  WeatherListPresenter.swift
//  Weather
//
//  Created by Jacky Tjoa on 23/9/24.
//

protocol WeatherListPresenterDelegate {
    func presentCityList(results: [ResultItem])
    func presentError(error: Error?)
}

class WeatherListPresenter: WeatherListPresenterDelegate {
    weak var view: WeatherListViewDelegate?
    
    func presentCityList(results: [ResultItem]) {
        let cellViewModelList = results.map {
            let displayText = "\($0.areaName.first?.value ?? ""), \($0.country.first?.value ?? "")"
            let cellViewModel = SearchCellViewModel(displayText: displayText)
            return cellViewModel
        }
        view?.displayCityList(cellViewModelList)
    }
    
    func presentError(error: Error?) {
        view?.displayErrorAlert(error: error)
    }
}
