//
//  SearchInteractor.swift
//  Weather
//
//  Created by Jacky Tjoa on 23/9/24.
//

protocol SearchInteractorDelegate {
    func onSearch(searchString: String)
    func didSelectItem(with data: SearchCellModel)
}

class SearchInteractor: SearchInteractorDelegate {
    var repository: WeatherRepositoryDelegate?
    var presenter: SearchPresenterDelegate?
    
    func onSearch(searchString: String) {
        repository?.fetchCityList(searchString: searchString, 
                                  success: { [weak self] response in
            self?.presenter?.presentCityList(results: response?.searchApi.result ?? [])
        }, failure: { [weak self] error in
            self?.presenter?.presentError(error: error)
        })
    }
    
    func didSelectItem(with data: SearchCellModel) {
        repository?.storeViewedCity(data: data)
    }
}
