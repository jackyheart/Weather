//
//  SearchInteractorTests.swift
//  WeatherTests
//
//  Created by Jacky Tjoa on 27/9/24.
//

import XCTest
@testable import Weather

final class SearchInteractorTests: XCTestCase {
    var sut: SearchInteractor!
    var presenterSpy: SearchPresenterSpy!
    
    override func setUp() {
        presenterSpy = SearchPresenterSpy()
        sut = SearchInteractor()
        sut.presenter = presenterSpy
    }
    
    override func tearDown() {
        presenterSpy = nil
        sut = nil
    }
    
    func testOnViewLoaded() {
        //TODO: to update
        XCTFail()
    }
    
    func testOnSearchEntered() {
        //TODO: to update
        XCTFail()
    }
    
    func testDidSelectItem() {
        //TODO: to update
        XCTFail()
    }
}

final class SearchPresenterSpy: SearchPresenterDelegate {
    var lastViewedResults: [ViewedItem] = []
    var searchResults: [ResultItem] = []
    var searchError: Error?
    
    func presentLastViewedCities(results: [ViewedItem], ordering: ItemOrdering) {
        lastViewedResults = results
    }
    
    func presentCityList(results: [ResultItem]) {
        searchResults = results
    }
    
    func presentError(error: Error?) {
        searchError = error
    }
}

final class MockRepository: WeatherRepositoryDelegate {
    var dataStore: [ViewedItem] = []
    var searchApiShouldReturnSuccess = true
    
    func storeViewedCity(data: ResultItem) {
        let viewedItem = DataModelConverter.convertDataModelToStorageModel(data: data,
                                                                           dateViewed: Date())
        dataStore.append(viewedItem)
    }
    
    func retrieveViewedCities(limit: Int) -> [ViewedItem] {
        return dataStore
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
