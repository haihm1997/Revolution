//
//  ProfileViewModel.swift
//  Revolution
//
//  Created by Hoang Hai on 21/07/2021.
//  Copyright © 2021 TonyHoang. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

class ProfileViewModel: BaseViewModel {
    
    let isPremium = BehaviorRelay<Bool>(value: false)
    
    override init() {
        super.init()
        
//        isPremium.accept(true)
    }
    
}
