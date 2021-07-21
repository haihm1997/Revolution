//
//  HomeEmptyView.swift
//  SmartPOS
//
//  Created by Hoang Hai on 01/06/2021.
//  Copyright © 2021 Teko. All rights reserved.
//

import UIKit
import SnapKit

class HomeEmptyView: BaseCustomView {
    
    let emptyImg = configure(UIImageView()) {
        $0.backgroundColor = .clear
        $0.image = UIImage(name: .homeEmpty)
        $0.contentMode = .scaleToFill
    }
    
    let contentLabel = configure(UILabel()) {
        $0.textColor = UIColor.gray
        $0.text = "Bản chưa có ảnh nào để hiển thị."
        $0.textAlignment = .center
    }
    
    let createOrderButton = configure(UIButton()) {
        $0.setTitle("Tạo ảnh", for: .normal)
    }
    
    let containerView  = configure(UIView()) {
        $0.backgroundColor = .clear
    }
    
    override func commonInit() {
        self.addSubviews(createOrderButton, contentLabel, emptyImg)
        
        emptyImg.snp.makeConstraints { (maker) in
            maker.top.leading.trailing.equalToSuperview()
            maker.width.equalTo(256)
            maker.height.equalTo(174)
        }
        
        contentLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(emptyImg.snp.bottom).offset(24)
            maker.leading.trailing.equalToSuperview()
        }
        
        createOrderButton.snp.makeConstraints { (maker) in
            maker.bottom.equalToSuperview()
            maker.top.equalTo(contentLabel.snp.bottom).offset(24)
            maker.width.equalTo(120)
            maker.height.equalTo(40)
            maker.centerX.equalToSuperview()
        }

    }
    
}

