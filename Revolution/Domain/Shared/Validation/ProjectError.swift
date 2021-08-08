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
    case noProductIDsFound
    case noProductsFound
    case paymentWasCancelled
    case productRequestFailed
    case other(error: Error)
    case generateVideoFailed
    case premiumRegisterFailed
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
        case .noProductIDsFound:
            return "Không tìm thấy id sản phẩm."
        case .noProductsFound:
            return "Không tìm thấy sản phẩm nào."
        case .productRequestFailed:
            return "Không thể lấy thông tin sản phẩm. Vui lòng thử lại sau."
        case .paymentWasCancelled:
            return "Thanh toán đã bị huỷ."
        case .generateVideoFailed:
            return "Có lỗi xảy ra xin thử lại sau"
        case .premiumRegisterFailed:
            return "Đăng ký Yummy Premium không thành công. Vui lòng thử lại sau"
        }
    }
    
}

extension RevolutionError: DomainErrorConvertible {
    public func asDomainError() -> RevolutionError {
        return self
    }
}
