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
        $0.image = UIImage(name: .basic)
        $0.backgroundColor = .clear
        $0.contentMode = .scaleToFill
    }
    
    let centerImage = configure(UIImageView()) {
        $0.image = UIImage(name: .basic)
        $0.backgroundColor = .clear
    }
    
    let containerImage = configure(UIView()) {
        $0.layer.cornerRadius = 60
        $0.layer.borderWidth = 5
        $0.layer.borderColor = UIColor.gray.cgColor
        $0.backgroundColor = .white
    }
    
    let premiumView = PremiumView()
    
    let restoreView = RestoreView()
    
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
        self.view.addSubviews(bannerImage, containerImage, basicPlanView, premiumPlanView, premiumView, restoreView)
        
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
        
        premiumView.snp.makeConstraints { maker in
            maker.trailing.equalToSuperview().inset(16)
            maker.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).inset(16)
            maker.height.equalTo(32)
        }
        
        restoreView.snp.makeConstraints { maker in
            maker.leading.equalToSuperview().inset(16)
            maker.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).inset(16)
            maker.height.equalTo(32)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        bind()
        updateState(isPremium: YummyPhotoApplication.shared.isPurchased)
    }
    
    private func bind() {
        viewModel.isPremium.bind(to: contentBinder).disposed(by: rx.disposeBag)
        premiumView.button.rx.tap
            .bind(to: didTapPurchase)
            .disposed(by: rx.disposeBag)
        restoreView.button.rx.tap
            .bind(to: viewModel.inRestoreProduct)
            .disposed(by: rx.disposeBag)
        viewModel.outActivity.bind(to: loadingBinder).disposed(by: rx.disposeBag)
        viewModel.outError.bind(to: didReceivedPurhaseError).disposed(by: rx.disposeBag)
        viewModel.outPurchaseSuccess.bind(to: didPurchaseSuccessBinder).disposed(by: rx.disposeBag)
        viewModel.outDidRestoreProduct.bind(to: didRestoreProductsBinder).disposed(by: rx.disposeBag)
    }
    
    private func updateState(isPremium: Bool) {
        basicPlanView.isHidden = isPremium
        premiumPlanView.isHidden = !isPremium
        premiumView.isHidden = isPremium
        restoreView.isHidden = isPremium
        bannerImage.image = isPremium ? UIImage(name: .premiun) : UIImage(name: .basic)
        centerImage.image = isPremium ? UIImage(name: .icPremium) : UIImage(name: .icBasic)
    }
    
}

extension ProfileViewController {
    
    var didPurchaseSuccessBinder: Binder<Bool> {
        return Binder(self) { target, isPurchased in
            target.updateState(isPremium: isPurchased)
        }
    }
    
    var contentBinder: Binder<Bool> {
        return Binder(self) { target, isPremium in
            target.bannerImage.image = isPremium ? UIImage(name: .premiun) : UIImage(name: .basic)
            target.centerImage.image = isPremium ? UIImage(name: .icPremium) : UIImage(name: .icBasic)
            target.basicPlanView.isHidden = isPremium ? true : false
            target.premiumPlanView.isHidden = isPremium ? false : true
        }
    }
    
    var didTapPurchase: Binder<Void> {
        return Binder(self) { target, _ in
            ErrorHandler.show2OptionAlert(message: "Sẵn sàng để trải nghiệm những tính năng tuyệt vời với Yummy Premium.",
                                          positiveTitleButton: "Đồng ý",
                                          from: target, didDismiss: nil) { [weak self] in
                self?.viewModel.inPurchasePremium.accept(())
            }
        }
    }
    
    var didReceivedPurhaseError: Binder<RevolutionError> {
        return Binder(self) { target, error in
            target.updateState(isPremium: false)
            ErrorHandler.showDefaultAlert(message: error.debugDescription ?? "", from: target, didDismiss: nil)
        }
    }
    
    var didRestoreProductsBinder: Binder<Bool> {
        return Binder(self) { target, isPremium in
            target.updateState(isPremium: isPremium)
        }
    }
    
}
