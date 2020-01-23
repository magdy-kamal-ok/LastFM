//
//  RequestHandlerProtocol.swift
//  LastFM
//
//  Created by Magdy Kamal on 1/23/20.
//  Copyright © 2020 OwnProjects. All rights reserved.
//

import Foundation

protocol RequstHandlerProtocol {
    func getApiUrl()                   -> String
    func getHttpMethod()               -> RequestMethod
    func getRequestHeaders()           -> [String:Any]?
    func getRequestParameters()        -> [String:Any]?
    func getRequestEncoding()          -> RequestEncoding?
}
