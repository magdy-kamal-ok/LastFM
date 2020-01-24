//
//  DataProvider.swift
//  LastFM
//
//  Created by Magdy Kamal on 1/23/20.
//  Copyright © 2020 OwnProjects. All rights reserved.
//

import Foundation
import RxSwift

class DataSourceProvider <R: Decodable> {
    
    private var requestHandler: RequstHandlerProtocol!
    private var apiClientManager: NetworkManagerProtocol!
    private var parser: ParserHandlerProtocol!
    private let bag = DisposeBag()
    private var subject = PublishSubject<(R?, Error?)>()
    public var observableResponse:Observable<(R?, Error?)> {
        return subject.asObservable()
    }
    
    init(requestHandler: RequstHandlerProtocol, apiClientManager: NetworkManagerProtocol = AlamofireApiClientManager(), parser: ParserHandlerProtocol = CodableParserManager()) {
        
        self.apiClientManager = apiClientManager
        self.requestHandler = requestHandler
        self.parser = parser
    }
    
    public func execute() {
        self.getRemoteData()
    }
    
    public func setApiParameters(params: [String: Any]?) {
        self.requestHandler.setRequestParameters(params: params)
    }
    private func getRemoteData() {
        if let observable:Observable<ResultModel> = self.fetchResponse(apiComponents: self.requestHandler) {
            observable.subscribe({ [weak self](subObj) in
                guard let self = self else {return}
                switch subObj {
                    case .next(let responseData):
                        let tupleResult = self.handleResult(response: responseData)
                        if let error = tupleResult.1 {
                            self.subject.onNext((nil, error))
                        }
                        if let response = tupleResult.0 {
                                self.subject.onNext((response, nil))
                        }
                    case .error(let error):
                        let error = self.handleError(error: error)
                        self.subject.onNext((nil, error))
                        
                    case .completed:
                        self.subject.onCompleted()
                }
                
            }).disposed(by: self.bag)
        }
    }
    private func handleResult(response: ResultModel) -> (R? ,Error?) {
        switch response {
        case .Faliure(let error):
            return (nil, self.handleError(error: error))
        case .success(let data):
            return self.handleSuccessData(data: data)
        }
    }
    
    private func handleSuccessData(data:Data) -> (R? ,Error?) {
        if let parsedObject:R = self.parser.parseData(data: data) {
            return (parsedObject, nil)
        }else {
            let error = self.createCustomError(localError: .parsingFailure)
            let returnError = self.handleError(error: error)
            return (nil, returnError)
        }
    }
    
    private func handleError(error:Error) -> Error {
        return error
    }
    
    private func createCustomError(localError: LocalError) -> ErrorModel {
        var error = ErrorModel.init()
        error.code = localError.errorCode
        error.message = localError.localizedDescription
        error.url = self.requestHandler.getApiUrl()
        return error
    }
}

extension DataSourceProvider: NetworkManagerProtocol {
    
    public func fetchResponse(apiComponents: RequstHandlerProtocol) -> Observable<ResultModel>? {
        
        if let objObserve:Observable<ResultModel> = apiClientManager.fetchResponse(apiComponents: self.requestHandler) {
            return objObserve
        }
        return Observable.empty()
    }
}
