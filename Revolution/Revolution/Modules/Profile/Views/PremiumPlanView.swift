//
//  PremiumPlanView.swift
//  Revolution
//
//  Created by Hai IT. Hoang Minh on 27/07/2021.
//  Copyright © 2021 TonyHoang. All rights reserved.
//

import UIKit
import SnapKit

class PremiumPlanView: BaseCustomView {
    
    let headerLabel = configure(UILabel()) {
        $0.text = "Quyền lợi"
        $0.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        $0.textColor = .textPrimary
    }
    
    let label1 = configure(UILabel()) {
        $0.text = "- Tạo album thoả thích cùng Yummy Photo."
        $0.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        $0.textColor = .textSecondary
    }
    
    let label2 = configure(UILabel()) {
        $0.text = "- Chỉnh sửa ảnh nâng cao cùng Yummy Photo."
        $0.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        $0.textColor = .textSecondary
    }
    
    let label3 = configure(UILabel()) {
        $0.text = "- Giao diện nâng cao."
        $0.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        $0.textColor = .textSecondary
    }
    
    let stackView = configure(UIStackView()) {
        $0.axis = .vertical
        $0.distribution = .fill
        $0.spacing = 6
    }
    
    override func commonInit() {
        super.commonInit()
        stackView.addArrangedSubviews(headerLabel, label1, label2, label3)
        
        self.addSubview(stackView)
        
        stackView.snp.makeConstraints { maker  in
            maker.top.leading.trailing.bottom.equalToSuperview()
        }
    }
    
}

