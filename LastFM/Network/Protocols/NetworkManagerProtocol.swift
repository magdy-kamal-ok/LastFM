//
//  NetworkManagerProtocol.swift
//  LastFM
//
//  Created by Magdy Kamal on 1/23/20.
//  Copyright © 2020 OwnProjects. All rights reserved.
//

import Foundation
import RxSwift

protocol NetworkManagerProtocol {
    
    func fetchResponse(apiComponents:RequstHandlerProtocol) -> Observable<ResultModel>?
    
}
