//
//  CodableParserManager.swift
//  LastFM
//
//  Created by Magdy Kamal on 1/23/20.
//  Copyright © 2020 OwnProjects. All rights reserved.
//

import Foundation

struct CodableParserManager: ParserHandlerProtocol {
    
    func parseData<T:Codable>(data: Data) -> T? {
        
        do {
            let decoder = JSONDecoder()
            let item = try decoder.decode(T.self, from: data)
            return item
            
        }catch {
            return nil
        }
    }
    
    
}
