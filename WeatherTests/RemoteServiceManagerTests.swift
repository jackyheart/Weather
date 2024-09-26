//
//  RemoteServiceManagerTests.swift
//  WeatherTests
//
//  Created by Jacky Tjoa on 27/9/24.
//

import XCTest
@testable import Weather

final class RemoteServiceManagerTests: XCTestCase {
    var sut: RemoteServiceManager!
    var spy: RemoteServiceSpy!
    
    override func setUp() {
        spy = RemoteServiceSpy()
        sut = RemoteServiceManager()
        sut.service = spy
    }
    
    override func tearDown() {
        sut = nil
    }
    
    func testFetchCityList() {
        sut.fetchCityList(searchString: "someSearchString") { response in } failure: { error in }
        XCTAssert(spy.fetchDataCalled)
        XCTAssertTrue(spy.passedURLString
            .contains("https://api.worldweatheronline.com/premium/v1/search.ashx"))
    }
}

final class RemoteServiceSpy: RemoteServiceDelegate {
    var fetchDataCalled = false
    var passedURLString = ""
    
    func fetchData<T>(urlString: String,
                      success: @escaping (T?) -> Void,
                      failure: @escaping ((any Error)?) -> Void) where T : Decodable {
        passedURLString = urlString
        fetchDataCalled = true
    }
}
