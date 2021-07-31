//
//  ProfileViewController.swift
//  Revolution
//
//  Created by Hoang Hai on 21/07/2021.
//  Copyright © 2021 TonyHoang. All rights reserved.
//

import UIKit
import RxCocoa
import SnapKit

class ProfileViewController: BaseViewController {
    
    let bannerImage = configure(UIImageView()) {
        $0.image = UIImage(name: .premiun)
        $0.backgroundColor = .clear
        $0.contentMode = .scaleToFill
    }
    
    let centerImage = configure(UIImageView()) {
        $0.image = UIImage(name: .icPremium)
        $0.backgroundColor = .clear
    }
    
    let containerImage = configure(UIView()) {
        $0.layer.cornerRadius = 60
        $0.layer.borderWidth = 5
        $0.layer.borderColor = UIColor.gray.cgColor
        $0.backgroundColor = .white
    }
    
    let basicPlanView = BasicPlanView()
    
    let premiumPlanView = PremiumPlanView()
    
    let viewModel = ProfileViewModel()
    
    override func loadView() {
        super.loadView()
        containerImage.addSubview(centerImage)
        centerImage.snp.makeConstraints { maker in
            maker.centerX.centerY.equalToSuperview()
            maker.width.height.equalTo(60)
        }
        self.view.addSubviews(bannerImage, containerImage, basicPlanView, premiumPlanView)
        
        bannerImage.snp.makeConstraints { maker in
            maker.top.leading.trailing.equalToSuperview()
            maker.height.equalTo(Constant.Size.screenWidth * 0.56)
        }
        
        containerImage.snp.makeConstraints { maker in
            maker.centerX.equalTo(bannerImage.snp.centerX)
            maker.bottom.equalTo(bannerImage.snp.bottom).inset(-60)
            maker.width.height.equalTo(120)
        }
        
        basicPlanView.snp.makeConstraints { maker in
            maker.top.equalTo(containerImage.snp.bottom).offset(16)
            maker.trailing.leading.equalToSuperview().inset(24)
        }
        
        premiumPlanView.snp.makeConstraints { maker in
            maker.top.equalTo(containerImage.snp.bottom).offset(16)
            maker.trailing.leading.equalToSuperview().inset(24)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        viewModel.isPremium.bind(to: contentBinder).disposed(by: rx.disposeBag)
    }
    
}

extension ProfileViewController {
    
    var contentBinder: Binder<Bool> {
        return Binder(self) { target, isPremium in
            target.bannerImage.image = isPremium ? UIImage(name: .premiun) : UIImage(name: .basic)
            target.centerImage.image = isPremium ? UIImage(name: .icPremium) : UIImage(name: .icBasic)
            target.basicPlanView.isHidden = isPremium ? true : false
            target.premiumPlanView.isHidden = isPremium ? false : true
        }
    }
    
}
