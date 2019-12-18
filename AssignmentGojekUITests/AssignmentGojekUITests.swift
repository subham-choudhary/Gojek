//
//  AssignmentGojekUITests.swift
//  AssignmentGojekUITests
//
//  Created by Subham Choudhary on 17/12/19.
//  Copyright © 2019 Subham Choudhary. All rights reserved.
//

import XCTest

class AssignmentGojekUITests: XCTestCase {

    var app: XCUIApplication!
    let fullname = "00 00"
    
    override func setUp() {
        continueAfterFailure = false
        
        app = XCUIApplication()
        app.launch()
    }

    override func tearDown() {
        app = nil
    }

    func addTestContact() {
        
        let firstName = "00"
        let lastName = "00"
        let phoneNumber = "0987654321"
        let email = "UITest1@giojek.com"

        app.navigationBars["Contacts"].buttons["Add"].tap()
        let elementsQuery = app.scrollViews.otherElements
        
        let tf1 = elementsQuery.textFields["tf1"]
        tf1.tap()
        tf1.typeText(firstName)

        let tf2 = elementsQuery.textFields["tf2"]
        tf2.tap()
        tf2.typeText(lastName)

        let tf3 = elementsQuery.textFields["tf3"]
        tf3.tap()
        
        tf3.typeText(phoneNumber)

        let tf4 = elementsQuery.textFields["tf4"]
        tf4.tap()
        tf4.typeText(email)

        app.navigationBars["AssignmentGojek.CreateEditView"].buttons["Done"].tap()
        app.sheets.scrollViews.otherElements.buttons["OK"].tap()
        
    }
    
    func getSearchResults(string: String)->Int {
        let searchBar = app.searchFields["Search"]
        searchBar.tap()
        searchBar.typeText(string)
        return(app.tables.cells.count)
    }
    
    func testCreateNewContact() {
        addTestContact()
        XCTAssertTrue(getSearchResults(string: fullname) > 0)
    }
    
    func testContactDelete() {
        addTestContact()
        let count = getSearchResults(string: fullname)
        let cell = app.tables.cells.firstMatch
        
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: cell, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        cell.tap()
        app.buttons["deleteBtn"].tap()
        let newCount = getSearchResults(string: fullname)
        XCTAssertTrue(count - newCount == 1)
    }
}
