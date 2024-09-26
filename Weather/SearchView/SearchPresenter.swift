//
//  SearchPresenter.swift
//  Weather
//
//  Created by Jacky Tjoa on 23/9/24.
//

protocol SearchPresenterDelegate {
    func presentCityList(results: [ResultItem])
    func presentError(error: Error?)
}

class SearchPresenter: SearchPresenterDelegate {
    weak var view: SearchViewDelegate?
    
    func presentCityList(results: [ResultItem]) {
        let resultListViewModel = results.map {
            let displayText = "\($0.areaName.first?.value ?? ""), \($0.country.first?.value ?? "")"
            let cellViewModel = SearchCellModel(displayText: displayText, 
                                                latitude: $0.latitude,
                                                longitude: $0.longitude)
            return cellViewModel
        }
        view?.displayResultList(resultListViewModel)
    }
    
    func presentError(error: Error?) {
        view?.displayErrorAlert(error: error)
    }
}
