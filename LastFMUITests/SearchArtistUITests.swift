//
//  SearchArtistUITests.swift
//  LastFMUITests
//
//  Created by Magdy Kamal on 1/27/20.
//  Copyright © 2020 OwnProjects. All rights reserved.
//

import XCTest
@testable import LastFM

class SearchArtistUITests: XCTestCase {
    var app: XCUIApplication!
    override func setUp() {
        super.setUp()
        app = XCUIApplication()
    }

    override func tearDown() {
        app = nil
        super.tearDown()
    }

    func openSearchArtist() {
        app.launch()
        app.navigationBars.firstMatch.buttons.firstMatch.tap()

    }
    
    func testOpenSearchArtistSuccess() {
        openSearchArtist()
        XCTAssert(app.staticTexts["Search Artists"].exists)
    }
    
    func testAlbumsTableViewExists() {
        openSearchArtist()
        XCTAssert(app.tables.firstMatch.exists)
    }
    
    func testArtistTableViewListLoaded() {
        app.launch()
        app.navigationBars.firstMatch.buttons.firstMatch.tap()
        let searchBar = app.searchFields.firstMatch
        searchBar.tap()
        searchBar.typeText("ASD\n")
        let tableView = app.tables.firstMatch
        let cells = tableView.cells
        let counts = NSPredicate(format: "count == 30")
        expectation(for: counts, evaluatedWith: cells, handler: nil)
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testArtistNameExists() {
        openSearchArtist()
        let searchBar = app.searchFields.firstMatch
        searchBar.tap()
        searchBar.typeText("ASD\n")
        let tableView = app.tables.firstMatch
        let firstCell = tableView.cells.element(boundBy: 0)
        let artistName = firstCell.children(matching: .staticText).firstMatch
        let exists = NSPredicate(format: "exists == 1")

        expectation(for: exists, evaluatedWith: artistName, handler: nil)
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testArtistNameAndListnersExists() {
        openSearchArtist()
        let searchBar = app.searchFields.firstMatch
        searchBar.tap()
        searchBar.typeText("ASD\n")
        let tableView = app.tables.firstMatch
        let firstCell = tableView.cells.element(boundBy: 0)
        let artistInfo = firstCell.children(matching: .staticText)
        let count = NSPredicate(format: "count == 2")

        expectation(for: count, evaluatedWith: artistInfo, handler: nil)
        waitForExpectations(timeout: 10, handler: nil)
    }
    
}
