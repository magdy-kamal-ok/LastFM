//
//  RequestFactory.swift
//  LastFM
//
//  Created by Magdy Kamal on 1/23/20.
//  Copyright © 2020 OwnProjects. All rights reserved.
//

import Foundation

class RequestFactory: RequstHandlerProtocol {

    var url: String
    var method: RequestMethod
    var headers: [String: Any]?
    var parameters: [String: Any]?
    var encoding: RequestEncoding?

    init(url: String,
         method: RequestMethod = .get,
         headers: [String: Any]? = ["Content-Type": "application/json"],
         parameters: [String: Any]? = nil,
         encoding: RequestEncoding? = .queryString) {
        self.url = url
        self.method = method
        self.headers = headers
        self.parameters = parameters
        self.encoding = encoding

    }
    
    func getApiUrl() -> String {
        return url
    }
    
    func getHttpMethod() -> RequestMethod {
        return method
    }
    
    func getRequestHeaders() -> [String : Any]? {
        return headers
    }
    
    func getRequestParameters() -> [String : Any]? {
        return parameters
    }
    
    func getRequestEncoding() -> RequestEncoding? {
        return encoding
    }
    
    func setRequestParameters(params: [String : Any]?) {
        self.parameters = params
    }
    
}
