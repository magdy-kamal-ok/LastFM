//
//  AlbumDetailsUITests.swift
//  LastFMUITests
//
//  Created by Magdy Kamal on 1/27/20.
//  Copyright © 2020 OwnProjects. All rights reserved.
//

import XCTest
@testable import LastFM

class AlbumDetailsUITests: XCTestCase {
    var app: XCUIApplication!
    override func setUp() {
        super.setUp()
        app = XCUIApplication()
    }

    override func tearDown() {
        app = nil
        super.tearDown()
    }

    func openAlbumsDetailsList() {
        app.launch()
        app.navigationBars.firstMatch.buttons.firstMatch.tap()
        let searchBar = app.searchFields.firstMatch
        searchBar.tap()
        searchBar.typeText("ASD\n")
        let artistTableView = app.tables.firstMatch
        let firstArtistCell = artistTableView.cells.element(boundBy: 0)
        firstArtistCell.tap()
        let albumTableView = app.tables.firstMatch
        let firstAlbumCell = albumTableView.cells.element(boundBy: 1)
        firstAlbumCell.tap()
        
    }
    
    func testOpenAlbumsSuccess() {
        openAlbumsDetailsList()
        XCTAssert(app.staticTexts["Blockbasta"].exists)
    }
    
    func testTracksCollectionViewExists() {
        openAlbumsDetailsList()
        XCTAssert(app.collectionViews.firstMatch.exists)
    }
    
    func testAlbumsImageViewExists() {
        openAlbumsDetailsList()
        XCTAssert(app.images.count >= 1)
    }
    
    func testTracksCollectionViewLoaded() {
         openAlbumsDetailsList()
         let collectionView = app.collectionViews.firstMatch
         let firstCell = collectionView.cells.element(boundBy: 0)
         let exists = NSPredicate(format: "exists == 1")
         expectation(for: exists, evaluatedWith: firstCell, handler: nil)
         waitForExpectations(timeout: 10, handler: nil)
     }
    
    func testTrackInfoExists() {
         openAlbumsDetailsList()
         let collectionView = app.collectionViews.firstMatch
         let firstCell = collectionView.cells.element(boundBy: 0)
         let trackInfo = firstCell.staticTexts
         let count = NSPredicate(format: "count == 2")
         expectation(for: count, evaluatedWith: trackInfo, handler: nil)
         waitForExpectations(timeout: 10, handler: nil)
     }
}
