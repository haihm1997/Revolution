//
//  HomeViewController.swift
//  Revolution
//
//  Created by Hoang Hai on 19/07/2021.
//  Copyright © 2021 TonyHoang. All rights reserved.
//

import Foundation

@objc public enum ZLImageEditorLanguageType: Int {
    case system
    case chineseSimplified
    case chineseTraditional
    case english
    case japanese
    case french
    case german
    case russian
    case vietnamese
    case korean
    case malay
    case italian
}

enum ZLLocalLanguageKey {
    case cancel
    case done
    case editFinish
    case revert
    case textStickerRemoveTips
    
    var title: String {
        switch self {
        case .cancel:
            return "Huỷ"
        case .done:
            return "Xong"
        case .editFinish:
            return "Xong"
        case .revert:
            return "Hoàn tác"
        case .textStickerRemoveTips:
            return "Kéo vào đây để xoá"
        }
    }
}

func localLanguageTextValue(_ key: ZLLocalLanguageKey) -> String {
    return key.title
}
