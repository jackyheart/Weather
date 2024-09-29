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
    
    func testOnViewWillAppear() {
        var dateViewedOrder: [Date] = []
        
        // no data initially
        sut.onViewWillAppear()
        XCTAssertEqual(presenterSpy.lastViewedResults.count, 0)
        
        // store 3 mock items, should expect 3 viewed items from local storage
        storeMockItems()
        sut.onViewWillAppear()
        XCTAssertEqual(presenterSpy.lastViewedResults.count, 3)
        
        // by default, date is ordered by descending order
        dateViewedOrder = presenterSpy.lastViewedResults.map { $0.dateViewed }
        
        // check item limit
        sut.kLastViewedLimit = 1
        sut.onViewWillAppear()
        XCTAssertEqual(presenterSpy.lastViewedResults.count, 1)
        XCTAssertEqual(presenterSpy.lastViewedResults[0].dateViewed, dateViewedOrder[0])
        
        sut.kLastViewedLimit = 2
        sut.onViewWillAppear()
        XCTAssertEqual(presenterSpy.lastViewedResults.count, 2)
        XCTAssertEqual(presenterSpy.lastViewedResults[0].dateViewed, dateViewedOrder[0])
        XCTAssertEqual(presenterSpy.lastViewedResults[1].dateViewed, dateViewedOrder[1])
        
        // check ascending order, date order should be reversed from previous retrieval
        sut.itemOrdering = .ascending
        sut.kLastViewedLimit = 3
        sut.onViewWillAppear()
        let ascendingDateOrder: [Date] = presenterSpy.lastViewedResults.map { $0.dateViewed }
        XCTAssertEqual(ascendingDateOrder, dateViewedOrder.reversed())
    }
    
    func testOnSearchTextEntered() {
        storeMockItems()
        sut.onViewWillAppear()
        
        sut.onSearchTextEntered(withSearchString: "Lon")
        XCTAssertEqual(presenterSpy.lastViewedResults.count, 3)
        
        sut.onSearchTextEntered(withSearchString: "lon")
        XCTAssertEqual(presenterSpy.lastViewedResults.count, 3)
        
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
