//
//  ImageCell.swift
//  Revolution
//
//  Created by Hoang Hai on 22/07/2021.
//  Copyright © 2021 TonyHoang. All rights reserved.
//

import UIKit
import SnapKit

class ImageCell: BaseCollectionViewCell {
    
    let imageView = configure(UIImageView()) {
        $0.backgroundColor = .clear
    }
    
    override func setupViews() {
        super.setupViews()
        self.contentView.addSubview(imageView)
        
        imageView.snp.makeConstraints { maker in
            maker.leading.trailing.top.bottom.equalToSuperview()
        }
    }
    
    func bind(image: UIImage) {
        self.imageView.image = image
    }
    
}
