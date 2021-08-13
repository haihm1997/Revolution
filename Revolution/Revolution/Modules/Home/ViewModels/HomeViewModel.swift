//
//  HomeViewModel.swift
//  Revolution
//
//  Created by Hoang Hai on 19/07/2021.
//  Copyright © 2021 TonyHoang. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay
import Photos

enum UserPlan {
    case basic
    case premium
    
    var stateLabel: String {
        switch self {
        case .basic:
            return "Try"
        case .premium:
            return "Premium Plan"
        }
    }
    
}

class HomeViewModel: BaseViewModel {
    
    var images: [UIImage] = []
    let outAllFonts = BehaviorRelay<[YummyFont]>(value: [])
    
    override init() {
        super.init()
        
        var tempFonts: [YummyFont] = []
        for family in UIFont.familyNames.sorted() {
            let names = UIFont.fontNames(forFamilyName: family)
            names.forEach {
                print("HomeViewModel Font: \($0)")
                tempFonts.append(YummyFont(font: UIFont(name: $0, size: 30) ?? UIFont.systemFont(ofSize: 26),
                                           name: $0))
            }
        }
        outAllFonts.accept(tempFonts)
    }
    
    
    
    
}
