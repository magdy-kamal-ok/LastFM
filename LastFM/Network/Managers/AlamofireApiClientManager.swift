//
//  AlamofireApiClientManager.swift
//  LastFM
//
//  Created by Magdy Kamal on 1/23/20.
//  Copyright © 2020 OwnProjects. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire


class AlamofireApiClientManager: NetworkManagerProtocol {
    
    init() {
    }
    
    func fetchResponse(apiComponents: RequstHandlerProtocol) -> Observable<ResultModel>? {
        return Observable.create { [weak self] observer in
            guard let self = self else {
                return Disposables.create {}
            }
            
            let url = apiComponents.getApiUrl()
            let method = self.getHTTPMethod(method: apiComponents.getHttpMethod())
            let parameters = apiComponents.getRequestParameters()
            let encoding = self.getEncoding(type: apiComponents.getRequestEncoding())
            let headers = self.getHeaders(headers: apiComponents.getRequestHeaders())
            // let responseType = apiComponents.getResponseType()
            let isReachable = NetworkReachabilityManager()?.isReachable == true
            if !isReachable {
                let customError = ErrorModel(code:  LocalError.noInternetConnection.errorCode, message: LocalError.noInternetConnection.localizedDescription, error: nil, url: url)
                observer.onNext(ResultModel.Faliure(customError))
                return Disposables.create {}
            }
            
            let request = Alamofire.request(url,
                                            method: method,
                                            parameters: parameters,
                                            encoding: encoding,
                                            headers: headers)
                .responseData { response in
                    switch response.result {
                    case .success(let data):
                        observer.onNext(ResultModel.success( data))
                    case .failure(let error):
                        let customError = ErrorModel(code:  response.response?.statusCode ?? 0, message: error.localizedDescription, error: nil, url: url)
                        observer.onNext(ResultModel.Faliure(customError))
                    }
            }
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    private func getHeaders(headers: [String: Any]?)-> HTTPHeaders? {
        if let headers = headers
        {
            return headers as? HTTPHeaders
        }
        return nil
    }
    
    private func getHTTPMethod(method: RequestMethod) -> HTTPMethod {
        return HTTPMethod(rawValue: method.rawValue) ?? HTTPMethod.get
    }
    
    private func getEncoding(type: RequestEncoding?) -> ParameterEncoding {
        switch type {
        case .urlEncoding?:
            return URLEncoding.default
        case .jsonEncoding?:
            return JSONEncoding.default
        case .queryString?:
            return URLEncoding.queryString
        default:
            return JSONEncoding.default
        }
    }
    
}
