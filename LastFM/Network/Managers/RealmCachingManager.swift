//
//  RealmCachingManager.swift
//  LastFM
//
//  Created by Magdy Kamal on 1/23/20.
//  Copyright © 2020 OwnProjects. All rights reserved.
//

import Foundation
import RealmSwift


public class RealmCachingManager: CachingManagerProtocol {

    public typealias U = Object
    var realm: Realm!
    
    public init(realm:Realm) {
        self.realm = realm
    }
    
    convenience public init() {
        let realm = (try? Realm())!
        self.init(realm: realm)
    }
    
    public func fetch<U>(predicate: NSPredicate?, type: U.Type) -> U? {
        do {
            if let type = type as? Object.Type {
                if let predicate = predicate {
                    let objects = self.realm.objects(type)
                    return objects.filter(predicate).first as? U
                }else {
                    let objects = self.realm.objects(type)
                    return objects.first as? U
                }
            }else {
                return nil
            }
        }catch {
            return nil
        }
    }
    
    public func fetchList<U>(predicate: NSPredicate?, type: U.Type) -> [U]? {
        do {
            if let type = type as? Object.Type {
                if let predicate = predicate {
                    let objects = self.realm.objects(type)
                    return objects.filter(predicate).itemsResltToArray() as? [U]
                }else {
                    let objects = self.realm.objects(type)
                    return objects.itemsResltToArray() as? [U]
                }
            }else {
                return nil
            }
        }catch {
            return nil
        }
    }
    
    public func insert<U>(genericDataModel: U) -> U? {
        do {
            if let genericDataModel = genericDataModel as? Object
            {
                realm.beginWrite()
                realm.add(genericDataModel, update: .modified)
                try realm.commitWrite()
                return genericDataModel as? U
            }else {
                return nil
            }
        }catch {
            return nil
        }
    }
    
    public func delete<U>(predicate: NSPredicate?, type: U.Type) -> U? {
        do {
            if let type = type as? Object.Type {
                if let predicate = predicate {
                    let objects = self.realm.objects(type)
                    if let objectsToDelete = objects.filter(predicate).first as? U, let objectToDelete = objectsToDelete as? Object {
                        realm.beginWrite()
                        realm.delete(objectToDelete, cascading: true)
                        try realm.commitWrite()
                        return objectsToDelete
                    }else {
                        return nil
                    }
                }else {
                    let objects = self.realm.objects(type)
                    if let objectsToDelete = objects.first as? U, let objectToDelete = objectsToDelete as? Object {
                        realm.beginWrite()
                        realm.delete(objectToDelete, cascading: true)

                        try realm.commitWrite()
                        return objectsToDelete
                    }else {
                        return nil
                    }
                }
            }else {
                return nil
            }
        }catch {
            return nil
        }
    }
}
