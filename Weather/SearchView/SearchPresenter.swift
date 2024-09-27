//
//  SearchPresenter.swift
//  Weather
//
//  Created by Jacky Tjoa on 23/9/24.
//

protocol SearchPresenterDelegate {
    func presentLastViewedCities(results: [LastViewedCity])
    func presentCityList(results: [ResultItem])
    func presentError(error: Error?)
}

class SearchPresenter: SearchPresenterDelegate {
    weak var view: SearchViewDelegate?
    
    func presentLastViewedCities(results: [LastViewedCity]) {
        let viewModelList = results.map {
            let dateString = Util.formatDate(date: $0.dateViewed)
            let viewModel = SearchCellModel(displayText: "\($0.city), \($0.country)",
                                            noteText: "Last viewed: \(dateString)",
                                            noteColor: .lightGray)
            return viewModel
        }
        view?.displayResultList(viewModelList)
    }
    
    func presentCityList(results: [ResultItem]) {
        let viewModelList = results.map {
            let displayText = "\($0.areaName.first?.value ?? ""), \($0.country.first?.value ?? "")"
            let viewModel = SearchCellModel(displayText: displayText,
                                            noteText: "",
                                            noteColor: .lightGray)
            return viewModel
        }
        view?.displayResultList(viewModelList)
    }
    
    func presentError(error: Error?) {
        view?.displayErrorAlert(error: error)
    }
}
