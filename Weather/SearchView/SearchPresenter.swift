//
//  SearchPresenter.swift
//  Weather
//
//  Created by Jacky Tjoa on 23/9/24.
//

import Foundation

protocol SearchPresenterDelegate {
    func presentLastViewedCities(results: [ViewedItem])
    func presentCityList(results: [ResultItem])
    func presentError(error: Error?)
}

class SearchPresenter: SearchPresenterDelegate {
    weak var view: SearchViewDelegate?
    
    func presentLastViewedCities(results: [ViewedItem]) {
        let viewModelList = results.map {
            convertDataModelToViewModel(data: $0.data,
                                        dateViewed: $0.dateViewed)
        }
        view?.displayResultList(viewModelList)
    }
    
    func presentCityList(results: [ResultItem]) {
        let viewModelList = results.map {
            return convertDataModelToViewModel(data: $0,
                                               dateViewed: nil)
        }
        view?.displayResultList(viewModelList)
    }
    
    func presentError(error: Error?) {
        view?.displayErrorAlert(error: error)
    }
    
    private func convertDataModelToViewModel(data: ResultItem,
                                             dateViewed: Date?) -> SearchCellModel {
        let displayText = "\(data.areaName.first?.value ?? ""), \(data.country.first?.value ?? "")"
        var noteText = ""
        if let dateViewed = dateViewed {
            let dateString = Util.formatDate(date: dateViewed)
            noteText = "Last viewed: \(dateString)"
        }
        let viewModel = SearchCellModel(displayText: displayText,
                                        noteText: noteText,
                                        noteTextColor: .gray)
        return viewModel
    }
}
