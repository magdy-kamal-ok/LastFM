//
//  AlbumsDetailsRepositoryTests.swift
//  LastFMTests
//
//  Created by Magdy Kamal on 1/27/20.
//  Copyright © 2020 OwnProjects. All rights reserved.
//

import XCTest
import RxSwift
import RealmSwift
@testable import LastFM
class AlbumsDetailsRepositoryTests: XCTestCase {
    
    var sut: AlbumsDetialsRepository?
    let artist = Artist(id: "868f7043-9de6-4b62-af8c-fcceb16b4bd6", name: "ASD", image: "https://lastfm.freetls.fastly.net/i/u/34s/2a96cbd8b46e442fc41c2b86b821562f.png", numberOfListeners: "68900")
    let album = Album(id: "Blockbasta", name: "Blockbasta", image: "https://lastfm.freetls.fastly.net/i/u/34s/7bc5bd6d24b73cfbeb79edd1e26e5056.png", numberOfPlays: "68755")
    let disposeBag = DisposeBag()
    
    override func setUp() {
        
        let dataProvider = DataProvider<AlbumDetailsResponseModel>(requestHandler: MockedRequestFactory(fileName: "AlbumDetailModelStub"), apiClientManager: MockedNetworkManager(), parser: CodableParserManager())
        var realmConf = Realm.Configuration()
        realmConf.inMemoryIdentifier = "TestFirst"
        guard let realm = try?(Realm(configuration: realmConf)) else {return}
         sut = AlbumsDetialsRepository(dataProvider: dataProvider, cachingManager: RealmCachingManager(realm: realm), artist: artist, album: album)
    }

    override func tearDown() {
        sut = nil
    }
    

    func testFetchAlbumDetailsSuccess() {
        let expectation = XCTestExpectation(description: "testFetchAlbumDetailsSuccess")
        var albumDetails: AlbumDetailModel?
        var error: ErrorModel?
        sut?
            .output
            .albumDetails
            .subscribe(onNext: { (response) in
                albumDetails = response
                expectation.fulfill()
            }).disposed(by: disposeBag)
        sut?
            .output
            .error
            .subscribe(onNext: { (responseError) in
                error = responseError
                expectation.fulfill()
            }).disposed(by: disposeBag)
        sut?.fetchAlbumDetails()
        wait(for: [expectation], timeout: 5)
        XCTAssertNotNil(albumDetails)
        XCTAssertNil(error)
        XCTAssertEqual(albumDetails?.tracks.count, 15)
    }
    
    func testFetchAlbumDetailsCachingSuccess() {
        let expectation = XCTestExpectation(description: "testFetchAlbumDetailsCachingSuccess")
        var isCached: Bool = false
        var error: ErrorModel?
        sut?
            .output
            .isCached
            .subscribe(onNext: { (isCachedFlag) in
                isCached = isCachedFlag
                expectation.fulfill()
            }).disposed(by: disposeBag)
        
        sut?
            .output
            .error
            .subscribe(onNext: { (responseError) in
                error = responseError
                expectation.fulfill()
            }).disposed(by: disposeBag)
        XCTAssertEqual(isCached, false)
        sut?.fetchAlbumDetails(with: album, isAutomaticalyCaching: true)
        wait(for: [expectation], timeout: 5)
        XCTAssertNil(error)
        XCTAssertEqual(isCached, true)
    }
    
    func testFetchAlbumDetailsNotCachingSuccess() {
        let expectation = XCTestExpectation(description: "testFetchAlbumDetailsNotCachingSuccess")
        var isCached: Bool = false
        var error: ErrorModel?
        sut?
            .output
            .isCached
            .subscribe(onNext: { (isCachedFlag) in
                isCached = isCachedFlag
                expectation.fulfill()
            }).disposed(by: disposeBag)
        sut?
            .output
            .error
            .subscribe(onNext: { (responseError) in
                error = responseError
                expectation.fulfill()
            }).disposed(by: disposeBag)
        XCTAssertEqual(isCached, false)
        sut?.fetchAlbumDetails()
        wait(for: [expectation], timeout: 5)
        XCTAssertNil(error)
        XCTAssertEqual(isCached, false)
    }
    
    func testFetchAlbumDetailsFromCachingSuccess() {
        let expectation = XCTestExpectation(description: "testFetchAlbumDetailsFromCachingSuccess")
        var albumDetailsList: [AlbumDetailModel]?
        var error: ErrorModel?
        sut?
            .output
            .albumDetailsList
            .subscribe(onNext: { (reponseList) in
                albumDetailsList = reponseList
                expectation.fulfill()
            }).disposed(by: disposeBag)
        sut?
            .output
            .error
            .subscribe(onNext: { (responseError) in
                error = responseError
                expectation.fulfill()
            }).disposed(by: disposeBag)
        sut?.fetchAlbumDetails(with: album, isAutomaticalyCaching: true)
        sut?.fetchAlbumListDetails()
        wait(for: [expectation], timeout: 5)
        XCTAssertNil(error)
        XCTAssertEqual(albumDetailsList?.count, 1)
    }
    
    func testFetchAlbumDetailsFromCachingIsEmpty() {
        let expectation = XCTestExpectation(description: "testFetchAlbumDetailsFromCachingIsEmpty")
        var albumDetailsList: [AlbumDetailModel]?
        var error: ErrorModel?
        sut?
            .output
            .albumDetailsList
            .subscribe(onNext: { (reponseList) in
                albumDetailsList = reponseList
                expectation.fulfill()
            }).disposed(by: disposeBag)
        sut?
            .output
            .error
            .subscribe(onNext: { (responseError) in
                error = responseError
                expectation.fulfill()
            }).disposed(by: disposeBag)
        sut?.fetchAlbumDetails()
        sut?.fetchAlbumListDetails()
        wait(for: [expectation], timeout: 5)
        XCTAssertEqual(albumDetailsList?.isEmpty, true)
        XCTAssertNil(error)
    }
    
}
