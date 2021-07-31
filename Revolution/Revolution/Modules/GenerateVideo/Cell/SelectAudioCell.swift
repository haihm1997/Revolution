//
//  SelectAudioCell.swift
//  Revolution
//
//  Created by Hai IT. Hoang Minh on 30/07/2021.
//  Copyright © 2021 TonyHoang. All rights reserved.
//

import UIKit

struct AudioModel {
    let name: String
    let orinalName: String
    var isSelected: Bool
}

class SelectAudioCell: BaseCollectionViewCell {
    
    let selectedImage = configure(UIImageView()) {
        $0.image = UIImage(name: .icSelected)
        $0.backgroundColor = .clear
    }
    
    let titleLabel = configure(UILabel()) {
        $0.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        $0.textColor = .textPrimary
        $0.numberOfLines = 1
    }
    
    override func setupViews() {
        super.setupViews()
        self.contentView.addSubviews(selectedImage, titleLabel)
        
        selectedImage.snp.makeConstraints { maker in
            maker.width.height.equalTo(13)
            maker.centerY.equalToSuperview()
            maker.leading.equalToSuperview().inset(8)
        }
        
        titleLabel.snp.makeConstraints { maker in
            maker.centerY.equalToSuperview()
            maker.leading.equalTo(selectedImage.snp.trailing).offset(8)
            maker.trailing.equalToSuperview().inset(16)
        }
    }
    
    func fill(audioModel: AudioModel) {
        self.titleLabel.text = audioModel.name
        self.selectedImage.isHidden = !audioModel.isSelected
    }
    
}
