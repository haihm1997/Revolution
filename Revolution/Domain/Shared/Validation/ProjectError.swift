//
//  ProjectError.swift
//  BaseMVVM
//
//  Created by Hoang Hai on 13/04/2021.
//  Copyright © 2021 TonyHoang. All rights reserved.
//

import Foundation

public enum RevolutionError: Error {
    case getMovieListFalied
    case lostInternetConnection
    case tokenInvalids
    case other(error: Error)
    case undefine
}

public extension RevolutionError {
    
    var debugDescription: String? {
        switch self {
        case .lostInternetConnection:
            return "Lost internet connection"
        case .getMovieListFalied:
            return "Get movie list falied!"
        case .tokenInvalids:
            return "Token Invalid!!!"
        case .other(let error):
            return error.localizedDescription
        case .undefine:
            return "Undefined error!"
        }
    }
    
}

extension RevolutionError: DomainErrorConvertible {
    public func asDomainError() -> RevolutionError {
        return self
    }
}
