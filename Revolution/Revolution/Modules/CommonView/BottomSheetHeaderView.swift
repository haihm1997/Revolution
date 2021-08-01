//
//  BottomSheetHeaderView.swift
//  Revolution
//
//  Created by Hai IT. Hoang Minh on 29/07/2021.
//  Copyright © 2021 TonyHoang. All rights reserved.
//

import UIKit
import RxCocoa

class BottomSheetHeaderView: BaseCustomView {
    
    let closeButton = configure(UIButton()) {
        $0.setImage(UIImage(name: .icClose), for: .normal)
        $0.backgroundColor = .clear
    }
    
    let titleLabel = configure(UILabel()) {
        $0.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        $0.textColor = .textPrimary
    }
    
    
    let leftButton = configure(UIButton()) {
        $0.backgroundColor = .clear
    }
    
    var title: String = "" {
        didSet {
            titleLabel.text = title
        }
    }
    
    let lineView = configure(UIView()) {
        $0.backgroundColor = .divided
    }
    
    var didTapLeftButton: (() -> Void)?
    
    override func commonInit() {
        super.commonInit()
        self.backgroundColor = .white
        self.addSubviews(closeButton, titleLabel, lineView, leftButton)
        
        closeButton.snp.makeConstraints { maker in
            maker.leading.equalToSuperview().inset(16)
            maker.width.height.equalTo(32)
            maker.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { maker in
            maker.centerX.centerY.equalToSuperview()
        }
        
        leftButton.snp.makeConstraints { maker in
            maker.centerY.equalToSuperview()
            maker.top.bottom.equalToSuperview()
            maker.width.equalTo(120)
            maker.leading.equalToSuperview()
        }
        
        lineView.snp.makeConstraints { maker in
            maker.bottom.equalToSuperview()
            maker.height.equalTo(1)
            maker.leading.trailing.equalToSuperview()
        }
        
        leftButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.didTapLeftButton?()
        }).disposed(by: rx.disposeBag)
    }
    
}
