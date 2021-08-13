//
//  YummyFont.swift
//  Revolution
//
//  Created by Hai IT. Hoang Minh on 10/08/2021.
//  Copyright © 2021 TonyHoang. All rights reserved.
//

import UIKit

struct YummyFont {
    let font: UIFont
    let name: String
    let previewContent: NSAttributedString
    
    init(font: UIFont, name: String) {
        self.font = font
        self.name = name
        let dict = [NSAttributedString.Key.font: font]
        let attributedText = NSAttributedString(string: "Yummy\nPhoto", attributes: dict)
        self.previewContent = attributedText
    }
}
