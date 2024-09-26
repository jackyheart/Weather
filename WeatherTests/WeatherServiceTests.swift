//
//  WeatherServiceTests.swift
//  WeatherTests
//
//  Created by Jacky Tjoa on 26/9/24.
//

import XCTest
@testable import Weather

final class WeatherServiceTests: XCTestCase {
    var sut: RemoteService!
    var mockHTTPClient: MockHTTPClient!
    
    override func setUp() {
        sut = RemoteService()
        mockHTTPClient = MockHTTPClient()
        sut.httpClient = mockHTTPClient
    }
    
    override func tearDown() {
        mockHTTPClient = nil
        sut = nil
    }
    
    func testFetchData() {
        mockHTTPClient.fileName = "search"
        sut.fetchData<SearchResponse>(query: "someQuery") { (result: SearchResponse?) -> Void in
            XCTAssertNotNil(result)
            XCTAssertEqual(result?.searchApi.result.count, 3)
        } failure: { error in
            XCTAssertNil(error)
        }
        
        mockHTTPClient.fileName = ""
        sut.fetchData<SearchResponse>(query: "someQuery") { (result: SearchResponse?) -> Void in
            XCTAssertNil(result)
        } failure: { error in
            XCTAssertNotNil(error)
        }
    }
}

final class MockHTTPClient: HTTPClientProtocol {
    var fileName: String = ""
    var shouldReturnSuccess = true
    
    func fetchData(urlString: String,
                   completion: @escaping (Data?, (any Error)?) -> Void) {
        if fileName.isEmpty {
            completion(nil, APIError.dataError)
        } else {
            let bundle = Bundle(for: MockHTTPClient.self)
            let path = bundle.path(forResource: fileName, ofType: "json")!
            let content = try! String(contentsOfFile: path)
            completion(Data(content.utf8), nil)
        }
    }
}
