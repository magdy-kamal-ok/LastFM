//
//  SearchArtistViewModelTests.swift
//  LastFMTests
//
//  Created by Magdy Kamal on 1/27/20.
//  Copyright © 2020 OwnProjects. All rights reserved.
//

import XCTest
import RxSwift
@testable import LastFM
class SearchArtistViewModelTests: XCTestCase {
    
    var sut: SearchArtistViewModel?
    let disposeBag = DisposeBag()
    
    override func setUp() {
        let dataProvider = DataProvider<ArtistResponseModel>(requestHandler: MockedRequestFactory(fileName: "ArtistsModelStub"), apiClientManager: MockedNetworkManager(), parser: CodableParserManager())
        sut = SearchArtistViewModel(dataSourceProvider: dataProvider, coordinator: nil)
    }

    override func tearDown() {
        sut = nil
    }
    

    func testFetchArtistListSuccess() {
        let expectation = XCTestExpectation(description: "testFetchArtistListSuccess")
        var artistList: [Artist]?
        var error: ErrorModel?
        sut?
            .output
            .artists
            .subscribe(onNext: { (responseList) in
                artistList = responseList
                expectation.fulfill()
            }).disposed(by: disposeBag)
        sut?
            .output
            .error
            .subscribe(onNext: { (responseError) in
                error = responseError
                expectation.fulfill()
            }).disposed(by: disposeBag)
        sut?.artistName = "ASD"
        wait(for: [expectation], timeout: 5)
        XCTAssertNotNil(artistList)
        XCTAssertNil(error)
        XCTAssertEqual(artistList?.count, 30)
    }
    
    func testFetchArtistListLoadMoreSucess() {
        let expectation = XCTestExpectation(description: "testFetchArtistListLoadMoreSucess")
        var artistList: [Artist]?
        sut?.output.artists.subscribe(onNext: { (responseList) in
            artistList = responseList
            expectation.fulfill()
            }).disposed(by: disposeBag)
        sut?.artistName = "ASD"
        sut?.loadMoreArtists()
        wait(for: [expectation], timeout: 5)
        XCTAssertNotNil(artistList)
        XCTAssertEqual(artistList?.count, 60)
    }
    
    func testFetchArtistListRefreshSucess() {
        let expectation = XCTestExpectation(description: "testFetchArtistListRefreshSucess")
        var artistList: [Artist]?
        sut?.output.artists.subscribe(onNext: { (responseList) in
            artistList = responseList
            expectation.fulfill()
            }).disposed(by: disposeBag)
        sut?.artistName = "ASD"
        sut?.loadMoreArtists()
        sut?.resetArtistList()
        wait(for: [expectation], timeout: 5)
        XCTAssertNotNil(artistList)
        XCTAssertEqual(artistList?.count, 30)
    }
}
