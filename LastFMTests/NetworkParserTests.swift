//
//  NetworkParserTests.swift
//  LastFMTests
//
//  Created by Magdy Kamal on 1/27/20.
//  Copyright © 2020 OwnProjects. All rights reserved.
//

import XCTest
@testable import LastFM

class NetworkParserTests: XCTestCase {

    var sut: ParserHandlerProtocol!

    override func setUp() {
        sut = CodableParserManager()
    }

    override func tearDown() {
        sut = nil
    }

    func testParsingDataSuccess() {

        let bundle = Bundle(for: NetworkParserTests.self)
        let dataPath = bundle.url(forResource: "ArtistsModelStub", withExtension: "json")
        let data = try! Data(contentsOf: dataPath!)
        var parsedArtistModel: ArtistResponseModelStub?
        if let artistModel: ArtistResponseModelStub = sut.parseData(data: data)
        {
            parsedArtistModel = artistModel
        }
        XCTAssertNotNil(parsedArtistModel)
        XCTAssert(parsedArtistModel?.results?.total == "2353")

    }
    
    func testParsingDataFailure() {
        let bundle = Bundle(for: NetworkParserTests.self)
        let dataPath = bundle.url(forResource: "ArtistModelFakeStub", withExtension: "json")
        let data = try! Data(contentsOf: dataPath!)
        var parsedArtistModel: ArtistResponseModelStub?
        if let artistModel: ArtistResponseModelStub = sut.parseData(data: data) {
            parsedArtistModel = artistModel
        }
        XCTAssertNil(parsedArtistModel)

    }

}

