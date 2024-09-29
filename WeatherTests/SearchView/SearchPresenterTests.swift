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
        super.setUp()
        viewSpy = SearchViewSpy()
        sut = SearchPresenter()
        sut.view = viewSpy
        prepareData()
    }
    
    override func tearDown() {
        resultItems.removeAll()
        viewSpy = nil
        sut = nil
        super.tearDown()
    }
    
    func prepareData() {
        let searchResponse: SearchResponse = MockDataManager.fetchMockResponse(fileName: "search")
        resultItems = searchResponse.searchApi.result
    }
    
    func testPresentLastViewedCities() {
        let viewDates = [
            "26 Sep 2024 09:48:13 AM",
            "27 Sep 2024 09:47:36 PM",
            "28 Sep 2024 09:31:24 PM"]
        
        let viewedItems = resultItems.enumerated().map { (index, element) in
            let dateString = viewDates[index]
            let date = DateUtil.shared.dateFromString(string: dateString)!
            let dataKey = DataModelConverter.constructDataKey(data: element)
            return DataModelConverter.convertDataModelToStorageModel(key: dataKey,
                                                                     data: element,
                                                                     dateViewed: date)
        }
        
        sut.presentLastViewedCities(results: viewedItems)
        
        let actualCityResults = viewSpy.cellModels.map { $0.displayText }
        let actualDateResults = viewSpy.cellModels.map { $0.noteText }
        
        let expectedCityResults = [
            "London, United Kingdom",
            "London, Canada",
            "Londonderry, United States of America"
        ]
        
        let expectedDateResults = [
            "Last viewed: 26 Sep 2024 09:48:13 AM",
            "Last viewed: 27 Sep 2024 09:47:36 PM",
            "Last viewed: 28 Sep 2024 09:31:24 PM"
        ]
        
        XCTAssertEqual(actualCityResults, expectedCityResults)
        XCTAssertEqual(actualDateResults, expectedDateResults)
    }
    
    func testPresentSearchedCityList() {
        sut.presentSearchedCityList(results: resultItems)
        
        let expectedCityList = [
            "London, United Kingdom",
            "London, Canada",
            "Londonderry, United States of America"
        ]
        
        let actualCityList = viewSpy.cellModels.map { $0.displayText }
        
        XCTAssertEqual(expectedCityList, actualCityList)
    }
    
    func testPresentError() {
        sut.presentError(error: APIError.noData)
        XCTAssertNotNil(viewSpy.errorResult)
        
        sut.presentError(error: nil)
        XCTAssertNil(viewSpy.errorResult)
    }
}

final class SearchViewSpy: SearchViewDelegate {
    var cellModels: [SearchCellModel] = []
    var errorResult: Error?
    
    func displayResultList(_ results: [SearchCellModel]) {
        cellModels = results
    }
    
    func displayErrorAlert(error: Error?) {
        errorResult = error
    }
}
