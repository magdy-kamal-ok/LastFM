//
//  MockedRequestFactory.swift
//  LastFMTests
//
//  Created by Magdy Kamal on 1/27/20.
//  Copyright © 2020 OwnProjects. All rights reserved.
//

import Foundation
@testable import LastFM

class MockedRequestFactory: RequstHandlerProtocol {

    var fileName: String
    
    init(fileName: String) {
        self.fileName = fileName
    }
    
    func getApiUrl() -> String {
        return fileName
    }
    
    func getHttpMethod() -> RequestMethod {
        return .get
    }
    
    func getRequestHeaders() -> [String : Any]? {
        return nil
    }
    
    func getRequestParameters() -> [String : Any]? {
        return nil
    }
    
    func getRequestEncoding() -> RequestEncoding? {
        return nil
    }
    
    func setRequestParameters(params: [String : Any]?) {

    }
    
}
