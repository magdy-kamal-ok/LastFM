//
//  AlbumsListUITests.swift
//  LastFMUITests
//
//  Created by Magdy Kamal on 1/27/20.
//  Copyright © 2020 OwnProjects. All rights reserved.
//

import XCTest
@testable import LastFM

class AlbumsListUITests: XCTestCase {
    var app: XCUIApplication!
    override func setUp() {
        super.setUp()
        app = XCUIApplication()
    }

    override func tearDown() {
        app = nil
        super.tearDown()
    }

    func openAlbumsList() {
        app.launch()
        app.navigationBars.firstMatch.buttons.firstMatch.tap()
        let searchBar = app.searchFields.firstMatch
        searchBar.tap()
        searchBar.typeText("ASD\n")
        let tableView = app.tables.firstMatch
        let firstCell = tableView.cells.element(boundBy: 0)
        firstCell.tap()
    }
    
    func testOpenAlbumsSuccess() {
        openAlbumsList()
        XCTAssert(app.staticTexts["ASD"].exists)
    }
    
    func testAlbumsTableViewExists() {
        openAlbumsList()
        XCTAssert(app.tables.firstMatch.exists)
    }
    
    func testAlbumsTableViewListLoaded() {
        openAlbumsList()
        let tableView = app.tables.firstMatch
        let cells = tableView.cells
        let counts = NSPredicate(format: "count == 50")
        expectation(for: counts, evaluatedWith: cells, handler: nil)
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testAlbumNameExists() {
        openAlbumsList()
        let tableView = app.tables.firstMatch
        let firstCell = tableView.cells.element(boundBy: 0)
        let albumName = firstCell.children(matching: .staticText).firstMatch
        let exists = NSPredicate(format: "exists == 1")

        expectation(for: exists, evaluatedWith: albumName, handler: nil)
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testAlbumInfoExists() {
        openAlbumsList()
        let tableView = app.tables.firstMatch
        let firstCell = tableView.cells.element(boundBy: 0)
        let albumInfo = firstCell.children(matching: .staticText)
        let count = NSPredicate(format: "count == 2")

        expectation(for: count, evaluatedWith: albumInfo, handler: nil)
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testAlbumDownloadButtonExists() {
        openAlbumsList()
        let tableView = app.tables.firstMatch
        let firstCell = tableView.cells.element(boundBy: 0)
        let downloadButton = firstCell.buttons.firstMatch
        let exists = NSPredicate(format: "exists == 1")

        expectation(for: exists, evaluatedWith: downloadButton, handler: nil)
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testAlbumDownloadButtonTapChangeTheIconSuccess() {
        openAlbumsList()
        let tableView = app.tables.firstMatch
        let firstCell = tableView.cells.element(boundBy: 0)
        let downloadButton = firstCell.buttons.firstMatch
        let buttonDescription = downloadButton.description
        downloadButton.tap()
        let tapedDescription = downloadButton.description
        XCTAssertFalse(buttonDescription == tapedDescription)
        
    }
}
