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
    
    var indexPath: IndexPath?
    
    let containerView = configure(UIView()) {
        $0.backgroundColor = .white
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.textSecondary.cgColor
        $0.layer.cornerRadius = 4
        $0.clipsToBounds = true
    }
    
    let imageView = configure(UIImageView()) {
        $0.backgroundColor = .clear
        $0.contentMode = .scaleAspectFit
    }
    
    let removeButton = configure(UIButton()) {
        $0.setImage(UIImage(name: .icRemove), for: .normal)
    }
    
    override func setupViews() {
        super.setupViews()
        self.containerView.addSubviews(imageView, removeButton)
        self.contentView.addSubview(containerView)
        
        imageView.snp.makeConstraints { maker in
            maker.leading.trailing.top.bottom.equalToSuperview()
        }
        
        containerView.snp.makeConstraints { maker in
            maker.leading.trailing.top.bottom.equalToSuperview()
        }
        
        removeButton.snp.makeConstraints { maker in
            maker.top.leading.equalToSuperview().inset(8)
            maker.width.height.equalTo(24)
        }
    }
    
    func bind(image: UIImage?) {
        self.imageView.image = image
    }
    
}

class SelectImageCell: BaseCollectionViewCell {
    
    let containerView = configure(UIView()) {
        $0.backgroundColor = .white
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.textSecondary.cgColor
        $0.layer.cornerRadius = 4
    }
    
    let imageView = configure(UIImageView()) {
        $0.backgroundColor = .clear
    }
    
    override func setupViews() {
        super.setupViews()
        self.contentView.addSubviews(containerView, imageView)
        
        containerView.snp.makeConstraints { maker in
            maker.top.leading.trailing.bottom.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { maker in
            maker.width.height.equalTo(36)
            maker.center.equalToSuperview()
        }
    }
    
    func bind(image: UIImage?) {
        self.imageView.image = image
    }
    
}
