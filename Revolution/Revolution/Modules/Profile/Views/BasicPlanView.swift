//
//  BasicPlanView.swift
//  Revolution
//
//  Created by Hai IT. Hoang Minh on 27/07/2021.
//  Copyright © 2021 TonyHoang. All rights reserved.
//

import UIKit
import SnapKit

class BasicContentView: BaseCustomView {
    
    let contentLabel = configure(UILabel()) {
        $0.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        $0.textColor = .textSecondary
        $0.numberOfLines = 0
    }
    
    let dotView: UIView = {
        let dotView = UIView()
        dotView.backgroundColor = .black
        dotView.layer.cornerRadius = 2
        return dotView
    }()
    
    override func commonInit() {
        self.addSubviews(dotView, contentLabel)
        dotView.snp.makeConstraints { maker in
            maker.leading.equalToSuperview()
            maker.width.height.equalTo(4)
            maker.top.equalToSuperview().inset(8)
        }
        
        contentLabel.snp.makeConstraints { maker in
            maker.top.equalToSuperview()
            maker.leading.equalTo(dotView.snp.trailing).offset(6)
            maker.trailing.equalToSuperview()
            maker.bottom.equalToSuperview()
        }
    }
    
    func fill(content: String) {
        contentLabel.text = content
    }
    
}

class BasicPlanView: BaseCustomView {
    
    let headerLabel = configure(UILabel()) {
        $0.text = "Đăng ký Yummy Premium ngay để tận hưởng những tính năng tuyệt vời."
        $0.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        $0.textColor = .textPrimary
        $0.numberOfLines = 0
    }
    
    let contents: [String] = ["Sở hữu bức ảnh đẹp lung linh với font chữ được Yummy thiết kế dành riêng cho bạn.",
                              "Thoả sức sáng tạo với những nét vẽ trên bức ảnh của bạn.",
                              "Thêm sticker cho bức ảnh của bạn thêm sống động.",
                              "Thoả sức sáng tạo với những nét vẽ trên bức ảnh của bạn.",
                              "Chờ đón những tính năng mới từ Yummy Photo mà không phải trả thêm phí."]
    
    let stackView = configure(UIStackView()) {
        $0.axis = .vertical
        $0.distribution = .fill
        $0.spacing = 6
    }
    
    override func commonInit() {
        super.commonInit()
        self.addSubviews(headerLabel, stackView)
        
        headerLabel.snp.makeConstraints { maker in
            maker.top.equalToSuperview()
            maker.leading.trailing.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { maker  in
            maker.top.equalTo(headerLabel.snp.bottom).offset(12)
            maker.leading.trailing.bottom.equalToSuperview()
        }
        
        for item in contents {
            let premiumContentView = BasicContentView()
            premiumContentView.fill(content: item)
            premiumContentView.layoutIfNeeded()
            stackView.addArrangedSubview(premiumContentView)
        }
    }
    
}
