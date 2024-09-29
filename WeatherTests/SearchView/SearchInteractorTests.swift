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
    var routerSpy: SearchRouterSpy!
    var mockRepositoryManager: MockRepositoryManager!
    var mockRepository: WeatherRepository!
    
    override func setUp() {
        super.setUp()
        presenterSpy = SearchPresenterSpy()
        routerSpy = SearchRouterSpy()
        mockRepositoryManager = MockRepositoryManager()
        mockRepository = mockRepositoryManager.getMockRepository()
        sut = SearchInteractor()
        sut.repository = mockRepository
        sut.presenter = presenterSpy
        sut.router = routerSpy
    }
    
    override func tearDown() {
        presenterSpy = nil
        routerSpy = nil
        mockRepositoryManager = nil
        mockRepository = nil
        sut = nil
        super.tearDown()
    }
    
    func storeMockItems() {
        let searchResponse: SearchResponse = MockDataManager.fetchMockResponse(fileName: "search")
        let resultItems = searchResponse.searchApi.result
        for item in resultItems {
            mockRepository.storeViewedCity(data: item)
        }
    }
    
    func testOnSearchTextEntered() {
        storeMockItems()
        
        sut.onSearchTextEntered(withSearchString: "")
        XCTAssertEqual(presenterSpy.lastViewedResults.count, 3)
        
        sut.onSearchTextEntered(withSearchString: "Londonderry")
        XCTAssertEqual(presenterSpy.lastViewedResults.count, 1)
        
        sut.onSearchTextEntered(withSearchString: "randomText")
        XCTAssertEqual(presenterSpy.lastViewedResults.count, 0)
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
        
        routerSpy.passedDataItem = nil
        sut.didSelectItem(onIndex: 0)
        var viewedItems = mockRepository.retrieveViewedCities(limit: 10, ordering: .descending)
        XCTAssertEqual(viewedItems.count, 1)
        XCTAssertEqual(routerSpy.passedDataItem?.areaName.first?.value, "London")
        XCTAssertEqual(routerSpy.passedDataItem?.country.first?.value, "United Kingdom")
        
        routerSpy.passedDataItem = nil
        sut.didSelectItem(onIndex: 1)
        viewedItems = mockRepository.retrieveViewedCities(limit: 10, ordering: .descending)
        XCTAssertEqual(viewedItems.count, 2)
        XCTAssertEqual(routerSpy.passedDataItem?.areaName.first?.value, "London")
        XCTAssertEqual(routerSpy.passedDataItem?.country.first?.value, "Canada")
        
        routerSpy.passedDataItem = nil
        sut.didSelectItem(onIndex: 2)
        viewedItems = mockRepository.retrieveViewedCities(limit: 10, ordering: .descending)
        XCTAssertEqual(viewedItems.count, 3)
        XCTAssertEqual(routerSpy.passedDataItem?.areaName.first?.value, "Londonderry")
        XCTAssertEqual(routerSpy.passedDataItem?.country.first?.value, "United States of America")
        
        //test out-of-bounds
        routerSpy.passedDataItem = nil
        sut.didSelectItem(onIndex: 100)
        viewedItems = mockRepository.retrieveViewedCities(limit: 10, ordering: .descending)
        XCTAssertEqual(viewedItems.count, 3)
        XCTAssertNil(routerSpy.passedDataItem)
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

final class SearchRouterSpy: SearchRouterDelegate {
    var passedDataItem: ResultItem?
    
    func navigateToDetailScreen(withDataItem dataItem: ResultItem?) {
        passedDataItem = dataItem
    }
}
