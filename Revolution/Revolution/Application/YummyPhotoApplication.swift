//
//  YummyPhotoApplication.swift
//  Revolution
//
//  Created by Hai IT. Hoang Minh on 07/08/2021.
//  Copyright © 2021 TonyHoang. All rights reserved.
//

import Foundation

class YummyPhotoApplication {
    
    static let shared = YummyPhotoApplication()
    
    var isPurchased: Bool = false
    
    private init() { }
    
    func appDidFinishLaunching() {
        IAPManager.shared.startObserving()
        IAPManager.shared.getProducts { _ in
            print("Get product success! ^^")
        }
        verifyPurchasing()
    }
    
    func verifyPurchasing() {
        let userDefault = UserDefaults.standard
        guard let isPurchased = userDefault.value(forKey: "isPurchased") as? Bool else {
            IAPManager.shared.verifyReceipt()
            return
        }
        if isPurchased {
            self.isPurchased = isPurchased
        } else {
            IAPManager.shared.verifyReceipt()
        }
    }
    
}
