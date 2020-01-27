//
//  DataProviderTests.swift
//  LastFMTests
//
//  Created by Magdy Kamal on 1/27/20.
//  Copyright © 2020 OwnProjects. All rights reserved.
//

import XCTest
import RxSwift
@testable import LastFM
class DataProviderTests: XCTestCase {

    var sut: DataProvider<ArtistResponseModelStub>?
    let disposeBag = DisposeBag()
    
    override func setUp() {

    }

    override func tearDown() {
        sut = nil
    }

    func testDataProviderSuccess() {
        let expectation = XCTestExpectation(description: "testDataProviderSuccess")
        let requestFactory = MockedRequestFactory(fileName: "ArtistsModelStub")
        sut = DataProvider(requestHandler: requestFactory, apiClientManager: MockedNetworkManager(), parser: CodableParserManager())
        var artistResponseModelStub: ArtistResponseModelStub?
        var error: ErrorModel?
        sut?.observableResponse.subscribe(onNext: { (response) in
            if let response = response.0 {
                artistResponseModelStub = response
            }else {
                error = response.1 as? ErrorModel
            }
            expectation.fulfill()
            }).disposed(by: disposeBag)
        sut?.execute()
        wait(for: [expectation], timeout: 5)
        XCTAssertNotNil(artistResponseModelStub)
        XCTAssertNil(error)
    }


    func testDataProviderFailure() {
        let expectation = XCTestExpectation(description: "testDataProviderFailure")
        let requestFactory = MockedRequestFactory(fileName: "ArtistModelFakeStub")
        sut = DataProvider(requestHandler: requestFactory, apiClientManager: MockedNetworkManager(), parser: CodableParserManager())
        var artistResponseModelStub: ArtistResponseModelStub?
        var error: ErrorModel?
        sut?.observableResponse.subscribe(onNext: { (response) in
            if let response = response.0 {
                artistResponseModelStub = response
            }else {
                error = response.1 as? ErrorModel
            }
            expectation.fulfill()
            }).disposed(by: disposeBag)
        sut?.execute()
        wait(for: [expectation], timeout: 5)
        XCTAssertNotNil(error)
        XCTAssertEqual(error?.code, LocalError.parsingFailure.errorCode)
        XCTAssertNil(artistResponseModelStub)

    }
}
