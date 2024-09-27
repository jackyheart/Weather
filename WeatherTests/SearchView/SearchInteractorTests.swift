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
    }
    
    override func tearDown() {
        presenterSpy = nil
        mockRepository = nil
        sut = nil
    }
    
    func testOnViewLoaded() {
        //TODO: to update
        XCTFail()
    }
    
    func testOnSearchEntered() {
        mockRepository.searchApiShouldReturnSuccess = true
        sut.onSearchEntered(searchString: "someSearchString")
        XCTAssertEqual(presenterSpy.searchResults.count, 3)

        mockRepository.searchApiShouldReturnSuccess = false
        sut.onSearchEntered(searchString: "someSearchString")
        XCTAssertNotNil(presenterSpy.searchError)
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
