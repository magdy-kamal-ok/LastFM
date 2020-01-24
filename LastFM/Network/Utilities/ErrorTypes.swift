//
//  ErrorTypes.swift
//  LastFM
//
//  Created by Magdy Kamal on 1/23/20.
//  Copyright © 2020 OwnProjects. All rights reserved.
//

import Foundation

enum LocalError: Error {
    
    case noInternetConnection
    case timeOut
    case parsingFailure
    case noCached
    case noUpdates
    case cachingFailed
    case removeFromCacheFailed
    case unknownError
    var localizedDescription: String {
        switch self {
        case .noInternetConnection: return "Internet Connection Error"
        case .timeOut: return "Time out"
        case .parsingFailure: return "Parsing Failure"
        case .noCached: return "No Cached Data We Will Request New Data"
        case .noUpdates:
            return "Could Not Update Local Data"
        case .cachingFailed:
            return "Could Not Cache To Local Data"
        case .removeFromCacheFailed:
            return "Could Not Remove From Local Data From Cache"
        case .unknownError:
            return "unknown Error Please Try Again after 1 minute"
        }
    }
    var errorCode:Int {
        switch self {
        case .noInternetConnection:
            return LocalErrorCode.noInternetConnection.rawValue
        case .timeOut:
            return LocalErrorCode.timeOut.rawValue
        case .parsingFailure:
            return LocalErrorCode.parsingFailure.rawValue
        case .noCached:
            return LocalErrorCode.noCached.rawValue
        case .noUpdates:
            return LocalErrorCode.noUpdates.rawValue
        case .cachingFailed:
            return LocalErrorCode.cachingFailed.rawValue
        case .removeFromCacheFailed:
            return LocalErrorCode.removeFromCacheFailed.rawValue
        case .unknownError:
            return LocalErrorCode.unknownError.rawValue
        }
    }
}

enum LocalErrorCode: Int {
    
    case noInternetConnection = 5000
    case timeOut = 5001
    case parsingFailure = 5002
    case noCached = 5003
    case noUpdates = 5004
    case cachingFailed = 5005
    case removeFromCacheFailed = 5006
    case unknownError = 5007
    
}
