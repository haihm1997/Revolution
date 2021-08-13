//
//  FontPreviewCell.swift
//  Revolution
//
//  Created by Hai IT. Hoang Minh on 09/08/2021.
//  Copyright © 2021 TonyHoang. All rights reserved.
//

import UIKit
import SnapKit

class FontPreviewCell: BaseCollectionViewCell {
    
    var indexPath: IndexPath?
    
    let containerView = configure(UIView()) {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 6
        $0.clipsToBounds = true
    }
    
    let previewLabel = configure(UILabel()) {
        $0.textColor = .textPrimary
        $0.text = "Yummy\nPhoto"
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    
    let lineView = configure(UIView()) {
        $0.backgroundColor = UIColor.divided
        $0.layer.cornerRadius = 6
    }
    
    let stateLabel = configure(UILabel()) {
        $0.textColor = .textPrimary
        $0.textAlignment = .center
        $0.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
    }
    
    let premiumImageView = configure(UIImageView()) {
        $0.image = UIImage(name: .icPremium)
        $0.contentMode = .scaleToFill
    }
    
    let stateStackView = configure(UIStackView()) {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.spacing = 2
    }
    
    let fontNameLabel = configure(UILabel()) {
        $0.textColor = .textPrimary
        $0.textAlignment = .center
        $0.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
    }
    
    override func setupViews() {
        super.setupViews()
        containerView.addSubviews(previewLabel, lineView, stateStackView)
        previewLabel.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.top.equalToSuperview().inset(32)
            maker.leading.equalToSuperview().inset(8)
        }
        
        lineView.snp.makeConstraints { maker in
            maker.leading.trailing.equalToSuperview()
            maker.height.equalTo(1)
            maker.bottom.equalToSuperview().inset(42)
        }
        
        stateStackView.addArrangedSubviews(stateLabel, premiumImageView)
        premiumImageView.snp.makeConstraints { maker in
            maker.width.height.equalTo(15)
        }
        
        stateStackView.snp.makeConstraints { maker in
            maker.bottom.equalToSuperview().inset(12)
            maker.centerX.equalToSuperview()
        }
        
        self.contentView.addSubview(containerView)
        containerView.snp.makeConstraints { maker in
            maker.leading.top.bottom.trailing.equalToSuperview().inset(8)
        }
        
        containerView.dropShadow(color: .gray, offSet: CGSize(width: 1, height: -1))

    }
    
    func bind(data: YummyFont, state: UserPlan) {
        previewLabel.attributedText = data.previewContent
        stateLabel.text = state == .premium ? "Premium" : "Thử"
        premiumImageView.isHidden = state == .basic
        fontNameLabel.text = data.name
    }
    
}
