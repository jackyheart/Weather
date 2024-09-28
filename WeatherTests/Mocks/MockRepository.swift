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
        let dataKey = DataModelConverter.constructDataKey(data: data)
        let viewedItem = DataModelConverter.convertDataModelToStorageModel(key: dataKey,
                                                                           data: data,
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
            let searchResponse: SearchResponse = MockDataManager.fetchMockResponse(fileName: "search")
            success(searchResponse)
        } else {
            failure(APIError.dataError)
        }
    }
    
    func fetchWeather(queryString: String, 
                      success: @escaping (WeatherResponse?) -> Void,
                      failure: @escaping (Error?) -> Void) {
        //TODO: to implement
    }
}

final class MockRepositoryManager {
    let mockLocalStorageManager = LocalStorageManager()
    let mockRemoteServiceManager = MockRemoteServiceManager()
    var shouldRemoteServiceReturnSuccessResponse: Bool = true {
        didSet {
            mockRemoteServiceManager.shouldReturnSuccessResponse = shouldRemoteServiceReturnSuccessResponse
        }
    }
    
    init() {
        mockLocalStorageManager.localSource = MockLocalStorage()
    }
    
    func getMockRepository() -> WeatherRepository {
        let repository = WeatherRepository()
        repository.localSource = mockLocalStorageManager
        repository.remoteSource = mockRemoteServiceManager
        return repository
    }
}
