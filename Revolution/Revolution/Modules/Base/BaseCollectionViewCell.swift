//
//  BaseCollectionViewCell.swift
//  BaseMVVM
//
//  Created by Hoang Hai on 22/04/2021.
//  Copyright © 2021 TonyHoang. All rights reserved.
//

import UIKit
import RxSwift

class BaseCollectionViewCell: UICollectionViewCell {
    
    var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    func setupViews() {
        self.contentView.backgroundColor = .clear
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.disposeBag = DisposeBag()
    }
    
}
