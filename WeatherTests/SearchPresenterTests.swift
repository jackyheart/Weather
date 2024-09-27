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
        let dateStrings = [
            "26 Sep 2024 09:48:13 AM",
            "27 Sep 2024 09:47:36 PM",
            "28 Sep 2024 09:31:24 PM"]
        
        let expectedCityOrder = [
            "London, United Kingdom",
            "London, Canada",
            "Londonderry, United States of America"
        ]
        
        let expectedDateOrder = [
            "Last viewed: 26 Sep 2024 09:48:13 AM",
            "Last viewed: 27 Sep 2024 09:47:36 PM",
            "Last viewed: 28 Sep 2024 09:31:24 PM"
        ]
        
        presenLastViewedCities(order: .ascending, 
                               inputDates: dateStrings,
                               expectedCityOrder: expectedCityOrder,
                               expectedDateOrder: expectedDateOrder)
        presenLastViewedCities(order: .descending,
                               inputDates: dateStrings,
                               expectedCityOrder: expectedCityOrder.reversed(),
                               expectedDateOrder: expectedDateOrder.reversed())
        
    }
    
    func presenLastViewedCities(order: ItemOrdering, 
                                inputDates: [String],
                                expectedCityOrder: [String],
                                expectedDateOrder: [String]) {
        let viewedItems = resultItems.enumerated().map { (index, element) in
            let dateString = inputDates[index]
            let date = DateUtil.shared.dateFromString(string: dateString)!
            return DataModelConverter.convertDataModelToStorageModel(data: element,
                                                                     dateViewed: date)
        }
        
        sut.presentLastViewedCities(results: viewedItems, ordering: order)

        let actualCityOrder = viewSpy.cellModels.map { $0.displayText }
        let actualDateOrder = viewSpy.cellModels.map { $0.noteText }
        XCTAssertEqual(actualCityOrder, expectedCityOrder)
        XCTAssertEqual(actualDateOrder, expectedDateOrder)
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
    var cellModels: [SearchCellModel] = []
    var errorResult: Error?
    
    func displayResultList(_ results: [SearchCellModel]) {
        cellModels = results
    }
    
    func displayErrorAlert(error: Error?) {
        errorResult = error
    }
}
