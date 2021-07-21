//
//  HomeHeaderView.swift
//  SmartPOS
//
//  Created by Hoang Hai on 31/05/2021.
//  Copyright © 2021 Teko. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift

class HomeHeaderView: UICollectionReusableView {
    
    let titleLabel = configure(UILabel()) {
        $0.textColor = UIColor.black
    }

    var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.disposeBag = DisposeBag()
    }
    
    private func setupViews() {
        addSubviews(titleLabel)
        
        titleLabel.snp.makeConstraints { (maker) in
            maker.centerY.equalToSuperview()
            maker.leading.equalToSuperview().inset(16)
        }
    }
    
    func bind(title: String) {
        titleLabel.text = title
    }
    
    
}
