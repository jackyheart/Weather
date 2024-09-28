//
//  MockRepository.swift
//  WeatherTests
//
//  Created by Jacky Tjoa on 28/9/24.
//

import Foundation
@testable import Weather

final class MockRepository: WeatherRepositoryDelegate {
    var dataStore: [ViewedItem] = []
    var searchApiShouldReturnSuccess = true
    
    func storeViewedCity(data: ResultItem) {
        let viewedItem = DataModelConverter.convertDataModelToStorageModel(data: data,
                                                                           dateViewed: Date())
        dataStore.append(viewedItem)
    }
    
    func retrieveViewedCities(limit: Int, ordering: ItemOrdering) -> [ViewedItem] {
        let sortedViews = dataStore.sorted(by: {
            switch ordering {
            case .descending:
                $0.dateViewed > $1.dateViewed
            case .ascending:
                $0.dateViewed < $1.dateViewed
            }
        })
        return Array(sortedViews.prefix(limit))
    }
    
    func fetchCityList(searchString: String,
                       success: @escaping (SearchResponse?) -> Void,
                       failure: @escaping (Error?) -> Void) {
        if searchApiShouldReturnSuccess {
            let searchResponse = MockDataManager.fetchMockResponse(fileName: "search",
                                                                   className: SearchResponse.self)
            success(searchResponse)
        } else {
            failure(APIError.dataError)
        }
    }
    
    func fetchWeather(city: String) {
    }
}
