//
//  Helper.swift
//  Revolution
//
//  Created by Hai IT. Hoang Minh on 30/07/2021.
//  Copyright © 2021 TonyHoang. All rights reserved.
//

import UIKit
import Photos
import BSImagePicker

extension PHAsset {

    var image: UIImage {
        var thumbnail = UIImage()
        PHImageManager.default().requestImage(for: self, targetSize: PHImageManagerMaximumSize,
                                              contentMode: .aspectFit,
                                              options: nil) { (image, info) in
            thumbnail = image ?? UIImage()
        }
        return thumbnail
    }
    
}
