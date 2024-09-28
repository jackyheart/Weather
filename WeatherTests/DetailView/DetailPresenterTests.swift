//
//  DetailPresenterTests.swift
//  WeatherTests
//
//  Created by Jacky Tjoa on 28/9/24.
//

import XCTest
@testable import Weather

final class DetailPresenterTests: XCTestCase {
    var sut: DetailPresenter!
    var viewSpy: DetailViewSpy!
    
    override func setUp() {
        viewSpy = DetailViewSpy()
        sut = DetailPresenter()
        sut.view = viewSpy
    }
    
    override func tearDown() {
        viewSpy = nil
        sut = nil
    }
    
    func testPresentError() {
        sut.presentError(error: APIError.dataError)
        XCTAssertNotNil(viewSpy.errorResult)
        
        sut.presentError(error: nil)
        XCTAssertNil(viewSpy.errorResult)
    }
}

final class DetailViewSpy: DetailViewControllerDelegate {
    var viewModel: DetailViewModel?
    var errorResult: Error?
    
    func displayResult(result: DetailViewModel) {
        viewModel = result
    }
    
    func displayErrorAlert(error: Error?) {
        errorResult = error
    }
}
