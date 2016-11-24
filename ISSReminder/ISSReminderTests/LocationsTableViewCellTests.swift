//
//  LocationsTableViewCellTests.swift
//  ISSReminder
//
//  Created by Rowun Giles on 11/23/16.
//  Copyright © 2016 Rowun Giles. All rights reserved.
//

import XCTest
@testable import ISSReminder

class LocationsTableViewCellTests: XCTestCase {
    
    func testConfigure_WhenCalled_SetsLabelText() {
        
        let expectedLabel = "test"
        let expectedTime = "1"
        
        let label = UILabel()
        let passTime = UILabel()
        
        let cell = LocationsTableViewCell()
        cell.label = label
        cell.passTime = passTime
        
        let location = Location(label: expectedLabel, coordinates: Coordinates(latitude: 50, longitude: 50))
        location?.nextRiseTime = expectedTime
        
        cell.configure(location: location!)
        
        XCTAssertEqual(cell.label.text, expectedLabel)
        XCTAssertEqual(cell.passTime.text, expectedTime)
    }
    
    func testPrepareForReuse_WhenCalled_SetsLabelTextToEmpty() {
        
        let expectedLabel = "test"
        
        let label = UILabel()
        let passTime = UILabel()
        
        let cell = LocationsTableViewCell()
        cell.label = label
        cell.passTime = passTime
        
        let location = Location(label: expectedLabel, coordinates: Coordinates(latitude: 50, longitude: 50))
        location?.nextRiseTime = "1"
        
        cell.configure(location: location!)
        
        XCTAssertEqual(cell.label.text, expectedLabel)
        
        cell.prepareForReuse()
        
        XCTAssertEqual(cell.label.text, "")
        XCTAssertEqual(cell.passTime.text, "")
    }
    
}
