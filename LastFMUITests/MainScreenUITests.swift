//
//  MainScreenUITests.swift
//  LastFMUITests
//
//  Created by Magdy Kamal on 1/27/20.
//  Copyright © 2020 OwnProjects. All rights reserved.
//

import XCTest
@testable import LastFM

class MainScreenUITests: XCTestCase {
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
    
    func addAlbumsToCache() {
        openAlbumsList()
        let tableView = app.tables.firstMatch
        tableView.cells.element(boundBy: 0).buttons.firstMatch.tap()
        tableView.cells.element(boundBy: 1).buttons.firstMatch.tap()
        app.navigationBars.buttons.element(boundBy: 0).tap()
        app.navigationBars.buttons.element(boundBy: 0).tap()
    }
    
    func testOpenMainScreenSuccess() {
        app.launch()
        XCTAssert(app.staticTexts["Main Screen"].exists)
    }
    
    func testCachedCollectionViewExists() {
        app.launch()
        XCTAssert(app.collectionViews.firstMatch.exists)
    }
    
    func testAddAlbunsToCollectionView() {
        addAlbumsToCache()
        let collectionView = app.collectionViews.firstMatch
        let firstCell = collectionView.cells.element(boundBy: 0)
        let exists = NSPredicate(format: "exists == 1")
        expectation(for: exists, evaluatedWith: firstCell, handler: nil)
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testOpenAlbumDetailsSuccess() {
        addAlbumsToCache()
        let collectionView = app.collectionViews.firstMatch
        let firstCell = collectionView.cells.element(boundBy: 0)
        firstCell.tap()
        let albumName = firstCell.staticTexts.firstMatch.label
        XCTAssert(app.staticTexts[albumName].exists)
    }
}
