//
//  MockedNetworkManager.swift
//  LastFMTests
//
//  Created by Magdy Kamal on 1/27/20.
//  Copyright © 2020 OwnProjects. All rights reserved.
//

import Foundation
import RxSwift
@testable import LastFM

/// this the MockedNetworkManager to enable us for using local stubs with out calling remote endpoint.
class MockedNetworkManager: NetworkManagerProtocol {
    func fetchResponse(apiComponents:RequstHandlerProtocol) -> Observable<ResultModel>? {
        let bundle = Bundle(for: MockedNetworkManager.self)
        let dataPath = bundle.url(forResource: apiComponents.getApiUrl(), withExtension: "json")
        return Observable.create { observer in
            var responseData: Data

            do {
                let data = try Data(contentsOf: dataPath!)
                let json = try JSONSerialization.jsonObject(with: data, options: []) as! Any
                let dataObj = try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted)
                responseData = dataObj
                observer.onNext(ResultModel.success(responseData))
            } catch {
                let customError = ErrorModel(code: LocalError.parsingFailure.errorCode, message: LocalError.parsingFailure.localizedDescription, error: LocalError.parsingFailure.localizedDescription, url: apiComponents.getApiUrl())
                
                observer.onNext(ResultModel.Faliure(customError))
            }
          
            return Disposables.create {
            }
        }
    }

}


