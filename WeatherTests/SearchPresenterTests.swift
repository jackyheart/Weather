//
//  SearchPresenterTests.swift
//  WeatherTests
//
//  Created by Jacky Tjoa on 27/9/24.
//

import XCTest
@testable import Weather

final class SearchPresenterTests: XCTestCase {
    var sut: SearchPresenter!
    var viewSpy: SearchViewSpy!
    var resultItems: [ResultItem] = []
    
    override func setUp() {
        viewSpy = SearchViewSpy()
        sut = SearchPresenter()
        sut.view = viewSpy
        prepareData()
    }
    
    override func tearDown() {
        resultItems.removeAll()
        viewSpy = nil
        sut = nil
    }
    
    func prepareData() {
        let searchResponse = MockDataManager.fetchMockResponse(fileName: "search",
                                                               className: SearchResponse.self)
        resultItems = searchResponse.searchApi.result
    }
    
    func testPresentLastViewedCities() {
        sut.presentLastViewedCities(results: [], ordering: .descending)
        //TODO: to update
        XCTFail()
    }
    
    func testPresentCityList() {
        sut.presentCityList(results: [])
        //TODO: to update
        XCTFail()
    }
    
    func testPresentError() {
        sut.presentError(error: APIError.dataError)
        //TODO: to update
        XCTFail()
    }
}

final class SearchViewSpy: SearchViewDelegate {
    var resultList: [SearchCellModel] = []
    var errorResult: Error?
    
    func displayResultList(_ results: [SearchCellModel]) {
        resultList = results
    }
    
    func displayErrorAlert(error: Error?) {
        errorResult = error
    }
}
