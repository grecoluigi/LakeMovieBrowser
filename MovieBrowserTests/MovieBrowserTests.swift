//
//  MovieBrowserTests.swift
//  MovieBrowserTests
//
//  Created by Karol Wieczorek on 04/11/2022.
//

import XCTest
@testable import MovieBrowser

final class MovieBrowserTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testHourConversion() throws {
        let durations = [0, 10, 59, 60, 100, 12345]
        let expectedResults = ["0m", "10m", "59m","1h", "1h 40m", "205h 45m"]
        for (index, duration) in durations.enumerated() {
            XCTAssertEqual(Helper.minutesToMinutesAndHours(durationInMinutes: duration), expectedResults[index])
        }
    }

}
