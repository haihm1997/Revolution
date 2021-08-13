//
//  StickerViewModel.swift
//  Revolution
//
//  Created by Hai IT. Hoang Minh on 09/08/2021.
//  Copyright © 2021 TonyHoang. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class StickerViewModel: BaseViewModel {
    
    let selectedImage: UIImage
    let selectedFont: YummyFont
    
    init(image: UIImage, selectedFont: YummyFont) {
        self.selectedImage = image
        self.selectedFont = selectedFont
    }
    
}
