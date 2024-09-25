//
//  WeatherListInteractor.swift
//  Weather
//
//  Created by Jacky Tjoa on 23/9/24.
//

protocol WeatherListInteractorDelegate {
    func onSearch(searchString: String)
}

class WeatherListInteractor: WeatherListInteractorDelegate {
    var repository: WeatherRepositoryDelegate?
    var presenter: WeatherListPresenterDelegate?
    
    func onSearch(searchString: String) {
        repository?.fetchCityList(searchString: searchString, success: { [weak self] response in
            self?.presenter?.presentCityList(results: response?.searchApi.result ?? [])
        }, failure: { [weak self] error in
            self?.presenter?.presentError(error: error)
        })
    }
}
