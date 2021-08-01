//
//  RealmVideo.swift
//  Revolution
//
//  Created by Hai IT. Hoang Minh on 31/07/2021.
//  Copyright © 2021 TonyHoang. All rights reserved.
//

import Foundation
import RealmSwift

class RealmVideo: Object {
    @objc dynamic var url: String = ""
    @objc dynamic var id: String = ""
    
    func toYMVideo() -> YMVideo {
        return YMVideo(self)
    }
}
