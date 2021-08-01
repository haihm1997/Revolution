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

class Utils {
    
    static func videoPreviewImage(url: URL) -> UIImage? {
        let asset = AVURLAsset(url: url)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        if let cgImage = try? generator.copyCGImage(at: CMTime(seconds: 2, preferredTimescale: 60), actualTime: nil) {
            return UIImage(cgImage: cgImage)
        }
        else {
            return nil
        }
    }
    
}
