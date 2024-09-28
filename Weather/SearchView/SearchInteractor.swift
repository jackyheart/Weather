//
//  SearchInteractor.swift
//  Weather
//
//  Created by Jacky Tjoa on 23/9/24.
//

protocol SearchInteractorDelegate {
    func onViewLoaded()
    func onSearchEntered(searchString: String)
    func didSelectItem(onIndex index: Int)
}

class SearchInteractor: SearchInteractorDelegate {
    var repository: WeatherRepositoryDelegate?
    var presenter: SearchPresenterDelegate?
    var kLastViewedLimit = 10
    var dataList: [ResultItem] = []
    
    func onViewLoaded() {
        let lastViewedCities = repository?.retrieveViewedCities(limit: kLastViewedLimit,
                                                                ordering: .descending) ?? []
        self.dataList = lastViewedCities.map { $0.data }
        presenter?.presentLastViewedCities(results: lastViewedCities)
    }
    
    func onSearchEntered(searchString: String) {
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
