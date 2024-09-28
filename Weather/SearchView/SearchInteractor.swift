//
//  SearchInteractor.swift
//  Weather
//
//  Created by Jacky Tjoa on 23/9/24.
//

protocol SearchInteractorDelegate {
    func onViewLoaded()
    func onSearchTextEntered(withSearchString searchString: String)
    func didPressSearch(withSearchString searchString: String)
    func didSelectItem(onIndex index: Int)
}

class SearchInteractor: SearchInteractorDelegate {
    var repository: WeatherRepositoryDelegate?
    var presenter: SearchPresenterDelegate?
    var kLastViewedLimit = 10
    var kLengthStartSearch = 1
    var dataList: [ResultItem] = []
    var viewedDataList: [ViewedItem] = []
    
    func onViewLoaded() {
        let lastViewedCities = repository?.retrieveViewedCities(limit: kLastViewedLimit,
                                                                ordering: .descending) ?? []
        self.viewedDataList = lastViewedCities
        self.dataList = lastViewedCities.map { $0.data }
        presenter?.presentLastViewedCities(results: lastViewedCities)
    }
    
    func onSearchTextEntered(withSearchString searchString: String) {
        var filteredViewedDataList: [ViewedItem] = []
        if searchString.isEmpty {
            filteredViewedDataList = viewedDataList
        } else if searchString.count >= kLengthStartSearch {
            filteredViewedDataList = viewedDataList.filter {
                $0.data.areaName.first?.value.hasPrefix(searchString) == true
            }
        } else {
            return
        }
        
        self.dataList = filteredViewedDataList.map { $0.data }
        presenter?.presentLastViewedCities(results: filteredViewedDataList)
    }
    
    func didPressSearch(withSearchString searchString: String) {
        repository?.fetchCityList(searchString: searchString,
                                  success: { [weak self] response in
            let resultList = response?.searchApi.result ?? []
            self?.dataList = resultList
            self?.presenter?.presentSearchedCityList(results: resultList)
        }, failure: { [weak self] error in
            self?.dataList.removeAll()
            self?.presenter?.presentError(error: error)
        })
    }
    
    func didSelectItem(onIndex index: Int) {
        if index < dataList.count {
            repository?.storeViewedCity(data: dataList[index])
        }
    }
}
