//
//  RequestFactoryTests.swift
//  LastFMTests
//
//  Created by Magdy Kamal on 1/27/20.
//  Copyright © 2020 OwnProjects. All rights reserved.
//

import XCTest
@testable import LastFM

class RequestFactoryTests: XCTestCase {
    var sut: RequstHandlerProtocol?
    let url = "https://ws.audioscrobbler.com/2.0/"
    
    override func setUp() {
        sut = RequestFactory(url: url)
    }

    override func tearDown() {
        sut = nil
    }


    func testRequestFactoryEndPointSuccess() {
        XCTAssert(sut?.getApiUrl() == url)
    }
    
    func testRequestFactoryEndPointFailure() {
        sut = nil
        XCTAssertNotEqual(sut?.getApiUrl(), url)
    }
}
