//
//  RealmCachingManagerTests.swift
//  LastFMTests
//
//  Created by Magdy Kamal on 1/26/20.
//  Copyright © 2020 OwnProjects. All rights reserved.
//

import XCTest
import RealmSwift
@testable import LastFM

class RealmCachingManagerTests: XCTestCase {
    
    var sut: RealmCachingManager?
    
    override func setUp() {
        var realmConf = Realm.Configuration.init()
        realmConf.inMemoryIdentifier = "TestFirst"
        guard let realm = try?(Realm(configuration: realmConf)) else {return}
        sut = RealmCachingManager(realm: realm)

    }

    override func tearDown() {
        sut = nil
    }
    
    func testCachObjectToRealmSuccess() {
        let testObject = TestObject(name: "Test", id: "id")
        let object = sut?.insert(genericDataModel: testObject)
        XCTAssertNotNil(object)
        
    }
    
    func testFetchCachObjectFromRealmSuccess() {
        let testObject = TestObject(name: "Test", id: "id")
        _ = sut?.insert(genericDataModel: testObject)
        let predicate = NSPredicate(format: "id=%@", "id")
        let object = sut?.fetch(predicate: predicate, type: TestObject.self)
        XCTAssertEqual(object?.id, "id")
    }

    func testFetchCachObjectFromRealmFailure() {
        let testObject = TestObject(name: "Test", id: "id")
        _ = sut?.insert(genericDataModel: testObject)
        let predicate = NSPredicate(format: "id=%@", "id")
        let object = sut?.fetch(predicate: predicate, type: TestObject.self)
        XCTAssertNotEqual(object?.id, "ID")
    }
    
    func testDeleteCachedObjectFromRealmSuccess() {
        let testObject = TestObject(name: "Test", id: "id")
        _ = sut?.insert(genericDataModel: testObject)
        let predicate = NSPredicate(format: "id=%@", "id")
        let object = sut?.delete(predicate: predicate, type: TestObject.self)
        XCTAssertNotNil(object)
    }
    
    func testDeleteCachedObjectFromRealmFailure() {
        let testObject = TestObject(name: "Test", id: "id")
        _ = sut?.insert(genericDataModel: testObject)
        let predicate = NSPredicate(format: "id=%@", "ID")
        let object = sut?.delete(predicate: predicate, type: TestObject.self)
        XCTAssertNil(object)
    }
}

class TestObject: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var id: String = ""
    
    required init() {
    }
    
    init(name: String, id: String) {
        self.name = name
        self.id = id
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
