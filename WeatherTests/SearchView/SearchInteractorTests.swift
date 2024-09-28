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
    var mockRepository: MockRepository!
    
    override func setUp() {
        presenterSpy = SearchPresenterSpy()
        mockRepository = MockRepository()
        sut = SearchInteractor()
        sut.presenter = presenterSpy
        sut.repository = mockRepository
        prepareData()
    }
    
    override func tearDown() {
        presenterSpy = nil
        mockRepository = nil
        sut = nil
    }
    
    func prepareData() {
        let searchResponse = MockDataManager.fetchMockResponse(fileName: "search",
                                                               className: SearchResponse.self)
        sut.dataList = searchResponse.searchApi.result
    }
    
    func testOnViewLoaded() {
        for item in sut.dataList {
            mockRepository.storeViewedCity(data: item)
        }
        
        sut.onViewLoaded()
        XCTAssertEqual(presenterSpy.lastViewedResults.count, 3)
        
        sut.kLastViewedLimit = 1
        sut.onViewLoaded()
        XCTAssertEqual(presenterSpy.lastViewedResults.count, 1)
    }
    
    func testOnSearchEntered() {
        mockRepository.searchApiShouldReturnSuccess = true
        sut.didPressSearch(withSearchString: "someSearchString")
        XCTAssertEqual(presenterSpy.searchResults.count, 3)

        mockRepository.searchApiShouldReturnSuccess = false
        sut.didPressSearch(withSearchString: "someSearchString")
        XCTAssertNotNil(presenterSpy.searchError)
    }
    
    func testDidSelectItem() {
        XCTAssertEqual(mockRepository.dataStore.count, 0)
        sut.didSelectItem(onIndex: 0)
        XCTAssertEqual(mockRepository.dataStore.count, 1)
        sut.didSelectItem(onIndex: 1)
        XCTAssertEqual(mockRepository.dataStore.count, 2)
        sut.didSelectItem(onIndex: 2)
        XCTAssertEqual(mockRepository.dataStore.count, 3)
    }
}

final class SearchPresenterSpy: SearchPresenterDelegate {
    var lastViewedResults: [ViewedItem] = []
    var searchResults: [ResultItem] = []
    var searchError: Error?
    
    func presentLastViewedCities(results: [ViewedItem]) {
        lastViewedResults = results
    }
    
    func presentSearchedCityList(results: [ResultItem]) {
        searchResults = results
    }
    
    func presentError(error: Error?) {
        searchError = error
    }
}
