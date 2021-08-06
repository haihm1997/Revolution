//
//  HomeEmptyView.swift
//  SmartPOS
//
//  Created by Hoang Hai on 01/06/2021.
//  Copyright © 2021 Teko. All rights reserved.
//

import UIKit
import SnapKit
import RxCocoa

class HomeEmptyView: BaseCustomView {
    
    let emptyImg = configure(UIImageView()) {
        $0.backgroundColor = .clear
        $0.image = UIImage(name: .homeEmpty)
        $0.contentMode = .scaleToFill
    }
    
    let contentLabel = configure(UILabel()) {
        $0.textColor = UIColor.gray
        $0.text = "Bản chưa có video nào để hiển thị."
        $0.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        $0.textAlignment = .center
    }
    
    let containerView  = configure(UIView()) {
        $0.backgroundColor = .clear
    }
    
    let createNewButton = configure(UIButton()) {
        $0.setTitle("Thêm mới", for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        $0.backgroundColor = .primary
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 4
    }
    
    let didTapCreateNew = PublishRelay<Void>()
    
    override func commonInit() {
        self.addSubviews(contentLabel, emptyImg, createNewButton)
        
        emptyImg.snp.makeConstraints { (maker) in
            maker.top.leading.trailing.equalToSuperview()
            maker.width.equalTo(226)
            maker.height.equalTo(144)
        }
        
        contentLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(emptyImg.snp.bottom).offset(16)
            maker.leading.trailing.equalToSuperview()
        }
        
        createNewButton.snp.makeConstraints { (maker) in
            maker.bottom.equalToSuperview()
            maker.top.equalTo(contentLabel.snp.bottom).offset(24)
            maker.width.equalTo(120)
            maker.height.equalTo(40)
            maker.centerX.equalToSuperview()
        }
        
        createNewButton.rx.tap.bind(to: didTapCreateNew).disposed(by: rx.disposeBag)
    }
    
}

