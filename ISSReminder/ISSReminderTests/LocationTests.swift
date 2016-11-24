//
//  LocationTests.swift
//  ISSReminder
//
//  Created by Rowun Giles on 11/23/16.
//  Copyright © 2016 Rowun Giles. All rights reserved.
//

import XCTest
@testable import ISSReminder

final class LocationTests: XCTestCase {

    fileprivate func stubJSONData() -> Data {
        
        let stubPath = Bundle(for: LocationTests.self).path(forResource: "iss-pass-stub", ofType: "json")!
        let jsonString = try! String(contentsOfFile: stubPath)
        let data = jsonString.data(using: .utf8)!
        
        return data
    }
}

extension LocationTests {
    func testLocationDiscoverRiseTime_WhenGivenData_SetsRiseTime() {
        
        let location = Location(label: "", coordinates: Coordinates(50,50))!
        
        let data = stubJSONData()
        
        let expected = "Nov 23, 2016, 5:03:43 PM"
        let actual = location.discoverRiseTime(from: .success(data))
        
        XCTAssertEqual(actual, expected)
    }
    
    func testLocationDiscoverRiseTime_WhenGivenError_SetsBlankTime() {
        
        let location = Location(label: "", coordinates: Coordinates(50,50))!

        let data = stubJSONData()
        
        let expected = "Nov 23, 2016, 5:03:43 PM"
        let actual = location.discoverRiseTime(from: .success(data))
        
        XCTAssertEqual(actual, expected)
        
        let expected2 = ""
        let actual2 = location.discoverRiseTime(from: .error(TestableError.generic))
        
        XCTAssertEqual(actual2, expected2)
    }
    
    func testDiscoverTime_WhenSet_CallsDelegate() {

        let mockDelegate = MockDelegate()
        
        let location = Location(label: "", coordinates: Coordinates(50,50))!
        location.delegate = mockDelegate
        location.nextRiseTime = "1"
        
        XCTAssertTrue(mockDelegate.didCallUpdatePassTime)
        
    }
}

private class MockDelegate: LocationDelegate {
    
    var didCallUpdatePassTime = false
    
    func didUpdatePassTime(for location: Location, time: String) {
        
        didCallUpdatePassTime = true
    }
}
