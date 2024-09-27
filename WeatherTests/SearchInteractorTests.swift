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
    var dataStore: [ResultItem] = []
    
    func storeViewedCity(data: ResultItem) {
        dataStore.append(data)
    }
    
    func retrieveViewedCities(limit: Int) -> [ViewedItem] {
        let inputDates = [
            "26 Sep 2024 09:48:13 AM",
            "27 Sep 2024 09:47:36 PM",
            "28 Sep 2024 09:31:24 PM"]
        
        let viewedItems = dataStore.enumerated().map { (index, element) in
            let dateString = inputDates[index]
            let date = DateUtil.shared.dateFromString(string: dateString)!
            return DataModelConverter.convertDataModelToStorageModel(data: element,
                                                                     dateViewed: date)
        }
        return viewedItems
    }
    
    func fetchCityList(searchString: String, 
                       success: @escaping (SearchResponse?) -> Void,
                       failure: @escaping ((any Error)?) -> Void) {
        
    }
    
    func fetchWeather(city: String) {
    }
}
