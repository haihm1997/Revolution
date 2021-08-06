//
//  IAPViews.swift
//  Revolution
//
//  Created by Hai IT. Hoang Minh on 06/08/2021.
//  Copyright © 2021 TonyHoang. All rights reserved.
//

import UIKit
import SnapKit

class PremiumView: BaseCustomView {
    
    let premiumLabel = configure(UILabel()) {
        $0.text = "Mua Premium"
        $0.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        $0.textColor = .gray
    }
    
    let premiumIcon = configure(UIImageView()) {
        $0.image = UIImage(name: .icPremium)
        $0.contentMode = .scaleAspectFit
        $0.backgroundColor = .clear
    }
    
    let button = configure(UIButton()) {
        $0.backgroundColor = .clear
    }
    
    override func commonInit() {
        self.backgroundColor = .white
        self.addSubviews(premiumLabel, premiumIcon, button)
        
        premiumLabel.snp.makeConstraints { maker in
            maker.centerY.equalToSuperview()
            maker.leading.equalToSuperview().inset(10)
        }
        
        premiumIcon.snp.makeConstraints { maker in
            maker.width.height.equalTo(18)
            maker.trailing.equalToSuperview().inset(10)
            maker.centerY.equalToSuperview()
            maker.leading.equalTo(premiumLabel.snp.trailing).offset(6)
        }
        
        button.snp.makeConstraints { maker in
            maker.leading.trailing.bottom.top.equalToSuperview()
        }
        
        self.layer.cornerRadius = 16
    }
    
}

class RestoreView: BaseCustomView {
    
    let premiumLabel = configure(UILabel()) {
        $0.text = "Restore"
        $0.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        $0.textColor = .gray
    }
    
    let premiumIcon = configure(UIImageView()) {
        $0.image = UIImage(name: .icRestore)
        $0.contentMode = .scaleAspectFit
        $0.backgroundColor = .clear
    }
    
    let button = configure(UIButton()) {
        $0.backgroundColor = .clear
    }
    
    override func commonInit() {
        self.backgroundColor = .white
        self.addSubviews(premiumLabel, premiumIcon, button)
        
        premiumLabel.snp.makeConstraints { maker in
            maker.centerY.equalToSuperview()
            maker.leading.equalToSuperview().inset(10)
        }
        
        premiumIcon.snp.makeConstraints { maker in
            maker.width.height.equalTo(18)
            maker.trailing.equalToSuperview().inset(10)
            maker.centerY.equalToSuperview()
            maker.leading.equalTo(premiumLabel.snp.trailing).offset(6)
        }
        
        button.snp.makeConstraints { maker in
            maker.leading.trailing.bottom.top.equalToSuperview()
        }
        
        self.layer.cornerRadius = 16
    }
    
}
