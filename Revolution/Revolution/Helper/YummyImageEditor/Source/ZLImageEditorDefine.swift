//
//  HomeViewController.swift
//  Revolution
//
//  Created by Hoang Hai on 19/07/2021.
//  Copyright © 2021 TonyHoang. All rights reserved.
//

import UIKit

struct ZLImageEditorLayout {
    
    static let bottomToolBtnH: CGFloat = 34
    
    static let bottomToolTitleFont = UIFont.systemFont(ofSize: 17)
    
    static let bottomToolBtnCornerRadius: CGFloat = 5
    
}

func zlRGB(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat) -> UIColor {
    return UIColor(red: red / 255, green: green / 255, blue: blue / 255, alpha: 1)
}

func getImage(_ named: String) -> UIImage? {
    return UIImage(named: named, in: Bundle.zlImageEditorBundle, compatibleWith: nil)
}

func deviceSafeAreaInsets() -> UIEdgeInsets {
    var insets: UIEdgeInsets = .zero
    
    if #available(iOS 11, *) {
        insets = UIApplication.shared.keyWindow?.safeAreaInsets ?? .zero
    }
    
    return insets
}

func zl_debugPrint(_ message: Any) {
//    debugPrint(message)
}
