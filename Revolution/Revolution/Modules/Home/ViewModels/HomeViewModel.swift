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

enum HomeSectionType {
    case highlightImage
    case allImages
}

class HomeViewModel: BaseViewModel {
    
    var highlightImages: [UIImage] = []
    var allImages: [UIImage] = []
    
}
