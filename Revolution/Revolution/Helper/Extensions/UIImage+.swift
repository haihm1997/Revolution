//
//  UIImage+.swift
//  BaseMVVM
//
//  Created by Hoang Hai on 29/04/2021.
//  Copyright © 2021 TonyHoang. All rights reserved.
//

import UIKit

extension UIImage {
    
    // Named raw string image's name in resource here
    enum Name: String {
        case back = "ic_back"
        case tabBarAddPhoto = "ic_add_photo"
        case tabBarHome = "ic_tabbar_home"
        case tabBarAccount = "ic_tabbar_account"
        case homeEmpty = "home_empty"
    }
    
    convenience init?(name: Name) {
        self.init(named: name.rawValue)
    }
    
}
