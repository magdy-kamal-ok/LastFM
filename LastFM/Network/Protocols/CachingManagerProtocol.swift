//
//  CachingManagerProtocol.swift
//  LastFM
//
//  Created by Magdy Kamal on 1/23/20.
//  Copyright © 2020 OwnProjects. All rights reserved.
//

import Foundation

public protocol CachingManagerProtocol {
    
    func fetch<U>(predicate: NSPredicate?, type: U.Type) -> U?
    
    func insert<U>(genericDataModel: U) -> U?
    
    func delete<U>(predicate: NSPredicate?, type: U.Type) -> U?
    
}
