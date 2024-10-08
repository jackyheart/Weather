//
//  SearchPresenter.swift
//  Weather
//
//  Created by Jacky Tjoa on 23/9/24.
//

enum ItemOrdering {
    case ascending
    case descending
}

protocol SearchPresenterDelegate {
    func presentLastViewedCities(results: [ViewedItem])
    func presentSearchedCityList(results: [ResultItem])
    func presentError(error: Error?)
}

final class SearchPresenter: SearchPresenterDelegate {
    weak var view: SearchViewDelegate?
    
    func presentLastViewedCities(results: [ViewedItem]) {
        let viewModelList = results.map {
            DataModelConverter.convertDataModelToViewModel(data: $0.data,
                                                           dateViewed: $0.dateViewed)
        }
        view?.displayResultList(viewModelList)
    }
    
    func presentSearchedCityList(results: [ResultItem]) {
        let viewModelList = results.map {
            DataModelConverter.convertDataModelToViewModel(data: $0,
                                                           dateViewed: nil)
        }
        view?.displayResultList(viewModelList)
    }
    
    func presentError(error: Error?) {
        view?.displayErrorAlert(error: error)
    }
}
