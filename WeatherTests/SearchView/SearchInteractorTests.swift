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
    var mockRepositoryManager: MockRepositoryManager!
    var mockRepository: WeatherRepository!
    
    override func setUp() {
        presenterSpy = SearchPresenterSpy()
        mockRepositoryManager = MockRepositoryManager()
        mockRepository = mockRepositoryManager.getMockRepository()
        sut = SearchInteractor()
        sut.repository = mockRepository
        sut.presenter = presenterSpy
    }
    
    override func tearDown() {
        presenterSpy = nil
        mockRepositoryManager = nil
        mockRepository = nil
        sut = nil
    }
    
    func storeMockItems() {
        let searchResponse: SearchResponse = MockDataManager.fetchMockResponse(fileName: "search")
        let resultItems = searchResponse.searchApi.result
        for item in resultItems {
            mockRepository.storeViewedCity(data: item)
        }
    }
    
    func testOnViewWillAppear() {
        storeMockItems()
        sut.onViewWillAppear()
        XCTAssertEqual(presenterSpy.lastViewedResults.count, 3)
    }
    
    func testOnSearchTextEntered() {
        storeMockItems()
        sut.onViewWillAppear()
        sut.onSearchTextEntered(withSearchString: "Lon")
        XCTAssertEqual(presenterSpy.lastViewedResults.count, 3)
        
        sut.onSearchTextEntered(withSearchString: "")
        XCTAssertEqual(presenterSpy.lastViewedResults.count, 3)
        
        sut.onSearchTextEntered(withSearchString: "Londonderry")
        XCTAssertEqual(presenterSpy.lastViewedResults.count, 1)
    }
    
    func testDidPressSearch() {
        mockRepositoryManager.shouldRemoteServiceReturnSuccessResponse = true
        sut.didPressSearch(withSearchString: "someSearchString")
        XCTAssertEqual(presenterSpy.searchResults.count, 3)
        
        mockRepositoryManager.shouldRemoteServiceReturnSuccessResponse = false
        sut.didPressSearch(withSearchString: "someSearchString")
        XCTAssertNotNil(presenterSpy.errorResult)
    }
    
    func testDidSelectItem() {
        sut.didPressSearch(withSearchString: "someSearchString")
        
        sut.didSelectItem(onIndex: 0)
        var viewedItems = mockRepository.retrieveViewedCities(limit: 10, ordering: .descending)
        XCTAssertEqual(viewedItems.count, 1)
        
        sut.didSelectItem(onIndex: 1)
        viewedItems = mockRepository.retrieveViewedCities(limit: 10, ordering: .descending)
        XCTAssertEqual(viewedItems.count, 2)
        
        sut.didSelectItem(onIndex: 2)
        viewedItems = mockRepository.retrieveViewedCities(limit: 10, ordering: .descending)
        XCTAssertEqual(viewedItems.count, 3)
        
        //test out-of-bounds
        sut.didSelectItem(onIndex: 100)
        viewedItems = mockRepository.retrieveViewedCities(limit: 10, ordering: .descending)
        XCTAssertEqual(viewedItems.count, 3)
    }
}

final class SearchPresenterSpy: SearchPresenterDelegate {
    var lastViewedResults: [ViewedItem] = []
    var searchResults: [ResultItem] = []
    var errorResult: Error?
    
    func presentLastViewedCities(results: [ViewedItem]) {
        lastViewedResults = results
    }
    
    func presentSearchedCityList(results: [ResultItem]) {
        searchResults = results
    }
    
    func presentError(error: Error?) {
        errorResult = error
    }
}
