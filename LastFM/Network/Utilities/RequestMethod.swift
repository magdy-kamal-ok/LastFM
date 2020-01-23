//
//  RequestMethod.swift
//  LastFM
//
//  Created by Magdy Kamal on 1/23/20.
//  Copyright © 2020 OwnProjects. All rights reserved.
//

import Foundation

enum RequestMethod:String {
    case post       = "POST"
    case get        = "GET"
    case put        = "PUT"
    case delete     = "DELETE"
}

enum RequestEncoding {
    case urlEncoding
    case jsonEncoding
    case queryString
}
