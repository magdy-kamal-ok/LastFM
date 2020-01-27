//
//  AlbumsViewModelTests.swift
//  LastFMTests
//
//  Created by Magdy Kamal on 1/27/20.
//  Copyright © 2020 OwnProjects. All rights reserved.
//

import XCTest
import RxSwift
@testable import LastFM
class AlbumsViewModelTests: XCTestCase {
    
    var sut: AlbumsViewModel?
    let artist = Artist(id: "868f7043-9de6-4b62-af8c-fcceb16b4bd6", name: "ASD", image: "https://lastfm.freetls.fastly.net/i/u/34s/2a96cbd8b46e442fc41c2b86b821562f.png", numberOfListeners: "68900")
    let disposeBag = DisposeBag()
    
    override func setUp() {
        
        let dataProvider = DataProvider<AlbumsResponseModel>(requestHandler: MockedRequestFactory(fileName: "AlbumsModelStub"), apiClientManager: MockedNetworkManager(), parser: CodableParserManager())
        sut = AlbumsViewModel(dataProvider: dataProvider, artist: artist, coordinator: nil)
    }

    override func tearDown() {
        sut = nil
    }
    

    func testFetchAlbumsListSuccess() {
        let expectation = XCTestExpectation(description: "testFetchAlbumsListSuccess")
        var albumList: [Album]?
        var error: ErrorModel?
        sut?
            .output
            .albums
            .subscribe(onNext: { (responseList) in
                albumList = responseList
                expectation.fulfill()
            }).disposed(by: disposeBag)
        sut?
            .output
            .error
            .subscribe(onNext: { (responseError) in
                error = responseError
                expectation.fulfill()
            }).disposed(by: disposeBag)
        sut?.artistName = artist.name ?? ""
        wait(for: [expectation], timeout: 5)
        XCTAssertNotNil(albumList)
        XCTAssertNil(error)
        XCTAssertEqual(albumList?.count, 50)
    }
    
    func testFetchAlbumsListLoadMoreSucess() {
        let expectation = XCTestExpectation(description: "testFetchAlbumsListLoadMoreSucess")
        var albumList: [Album]?
        sut?.output.albums.subscribe(onNext: { (responseList) in
            albumList = responseList
            expectation.fulfill()
            }).disposed(by: disposeBag)
        sut?.artistName = artist.name ?? ""
        sut?.loadMoreAlbums()
        wait(for: [expectation], timeout: 5)
        XCTAssertNotNil(albumList)
        XCTAssertEqual(albumList?.count, 100)
    }
    
    func testFetchAlbumsListRefreshSucess() {
        let expectation = XCTestExpectation(description: "testFetchAlbumsListRefreshSucess")
        var albumList: [Album]?
        sut?.output.albums.subscribe(onNext: { (responseList) in
            albumList = responseList
            expectation.fulfill()
            }).disposed(by: disposeBag)
        sut?.artistName = artist.name ?? ""
        sut?.loadMoreAlbums()
        sut?.resetAlbumList()
        wait(for: [expectation], timeout: 5)
        XCTAssertNotNil(albumList)
        XCTAssertEqual(albumList?.count, 50)
    }
}
