//
//  ISSReminderUITests.swift
//  ISSReminderUITests
//
//  Created by Rowun Giles on 11/23/16.
//  Copyright © 2016 Rowun Giles. All rights reserved.
//

import XCTest

class LocationsTableViewControllerUITests: XCTestCase {
        
    override func setUp() {
        
        super.setUp()
        
        continueAfterFailure = false

        XCUIApplication().launch()
    }
    
    func testAddingLocation() {
        
        let app = XCUIApplication()
        
        app.navigationBars["ISSReminder.LocationsTableView"].buttons["Add"].tap()
        
        let labelTextField = app.textFields["Label"]
        labelTextField.tap()
        labelTextField.typeText("Example")
        
        let locationTextField = app.textFields["Location"]
        locationTextField.tap()
        locationTextField.typeText("London, UK")
        
        app.navigationBars.buttons["Done"].tap()
    }
}
