//
//  AddView.swift
//  Revolution
//
//  Created by Hai IT. Hoang Minh on 01/08/2021.
//  Copyright © 2021 TonyHoang. All rights reserved.
//

import UIKit
import SnapKit
import RxCocoa

class AddView: BaseCustomView {
    
    let addImageView = configure(UIImageView()) {
        $0.image = UIImage(name: .icAddMovie)
        $0.backgroundColor = .clear
    }
    
    let addButton = configure(UIButton()) {
        $0.backgroundColor = .clear
    }
    
    let didTapAddButton = PublishRelay<Void>()
    
    override func commonInit() {
        super.commonInit()
        self.backgroundColor = .primary
        self.addSubviews(addImageView, addButton)
        
        addImageView.snp.makeConstraints { maker in
            maker.leading.trailing.top.bottom.equalToSuperview().inset(18)
        }
        
        addButton.snp.makeConstraints { maker in
            maker.leading.trailing.top.bottom.equalToSuperview()
        }
    
        addButton.rx.tap
            .bind(to: didTapAddButton)
            .disposed(by: rx.disposeBag)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.width / 2
    }
    
}
