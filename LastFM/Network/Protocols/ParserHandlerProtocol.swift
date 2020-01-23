//
//  ParserHandlerProtocol.swift
//  LastFM
//
//  Created by Magdy Kamal on 1/23/20.
//  Copyright © 2020 OwnProjects. All rights reserved.
//

import Foundation

public protocol ParserHandlerProtocol {
    
    func parseData<T:Codable>(data:Data) -> T?
}
