//
//  DetailInteractorTests.swift
//  WeatherTests
//
//  Created by Jacky Tjoa on 28/9/24.
//

import XCTest
@testable import Weather

final class DetailInteractorTests: XCTestCase {
    var sut: DetailInteractor!

    override func setUp() {
        sut = DetailInteractor()
    }
    
    override func tearDown() {
        sut = nil
    }
}

final class DetailPresenterSpy: DetailPresenterDelegate {
    var dataItem: ResultItem?
    var weatherResult: WeatherCondition?
    var errorResult: Error?
    
    func presentWeatherResult(onDataItem dataItem: ResultItem?,
                              result: WeatherCondition?) {
        self.dataItem = dataItem
        weatherResult = result
    }
    
    func presentError(error: Error?) {
        errorResult = error
    }
}
