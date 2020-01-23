//
//  ErrorModel.swift
//  LastFM
//
//  Created by Magdy Kamal on 1/23/20.
//  Copyright © 2020 OwnProjects. All rights reserved.
//

import Foundation

public struct ErrorModel: Error {
    var code: Int?
    var message: String?
    var error: String?
    var url: String?
    
    public init(code: Int?, message: String?, error: String?, url: String?) {
        self.code = code
        self.message = message
        self.error = error
        self.url = url
    }

    public init() {
        self.init(code: nil, message: nil, error: nil, url: nil)
    }
}
