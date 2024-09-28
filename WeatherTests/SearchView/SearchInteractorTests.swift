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
        let searchResponse: SearchResponse = MockDataManager.fetchMockResponse(fileName: "search")
        sut.dataList = searchResponse.searchApi.result
        
        //TODO: update MockRepository implementation
        for item in sut.dataList {
            mockRepository.storeViewedCity(data: item)
        }
        sut.viewedDataList = mockRepository.retrieveViewedCities(limit: 10, ordering: .descending)
    }
    
    func testOnViewWillAppear() {
        sut.onViewWillAppear()
        XCTAssertEqual(presenterSpy.lastViewedResults.count, 3)
        
        sut.kLastViewedLimit = 1
        sut.onViewWillAppear()
        XCTAssertEqual(presenterSpy.lastViewedResults.count, 1)
    }
    
    func testOnSearchTextEntered() {
        sut.onSearchTextEntered(withSearchString: "")
        XCTAssertEqual(presenterSpy.lastViewedResults.count, 3)
        
        sut.onSearchTextEntered(withSearchString: "Lon")
        XCTAssertEqual(presenterSpy.lastViewedResults.count, 3)
        
        sut.onSearchTextEntered(withSearchString: "Londonderry")
        XCTAssertEqual(presenterSpy.lastViewedResults.count, 1)
    }
    
    func testDidPressSearch() {
        mockRepository.searchApiShouldReturnSuccess = true
        sut.didPressSearch(withSearchString: "someSearchString")
        XCTAssertEqual(presenterSpy.searchResults.count, 3)

        mockRepository.searchApiShouldReturnSuccess = false
        sut.didPressSearch(withSearchString: "someSearchString")
        XCTAssertNotNil(presenterSpy.searchError)
    }
    
    func testDidSelectItem() {
        XCTAssertEqual(mockRepository.dataStore.count, 3)
        sut.didSelectItem(onIndex: 0)
        XCTAssertEqual(mockRepository.dataStore.count, 4)
        sut.didSelectItem(onIndex: 1)
        XCTAssertEqual(mockRepository.dataStore.count, 5)
        sut.didSelectItem(onIndex: 2)
        XCTAssertEqual(mockRepository.dataStore.count, 6)
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
