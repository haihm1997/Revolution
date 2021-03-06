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
import PanModal

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
            .bind(to: didTapTermConditionBinder)
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
            let premiumVC = PremiumRegisterViewController()
            premiumVC.didTapPurchase = {
                target.viewModel.inPurchasePremium.accept(())
            }
            premiumVC.didTapRestore = {
                target.viewModel.inRestoreProduct.accept(())
            }
            target.presentPanModal(premiumVC)
        }
    }
    
    var didTapTermConditionBinder: Binder<Void> {
        return Binder(self) { target, _ in
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: "Điều khoản sử dụng", style: .default , handler:{ (UIAlertAction)in
                target.openWebView(title: "Điều khoản sử dụng",
                                   url: "https://tngstudio.blogspot.com/2021/07/terms-of-vip-service.html")
            }))
            
            alert.addAction(UIAlertAction(title: "Chính sách bảo mật", style: .default , handler:{ (UIAlertAction)in
                target.openWebView(title: "Chính sách bảo mật",
                                   url: "https://tngstudio.blogspot.com/2021/07/policy.html")
            }))
            
            alert.addAction(UIAlertAction(title: "Đóng", style: .cancel, handler:{ (UIAlertAction)in
                print("User click Dismiss button")
            }))
            
            target.present(alert, animated: true, completion: nil)
        }
    }
    
    private func openWebView(title: String, url: String) {
        let webVC = YummyWebView()
        webVC.title = title
        webVC.urlStr = url
        self.present(webVC, animated: true, completion: nil)
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
            ErrorHandler.showDefaultAlert(message: "Hoàn thành!", from: target, didDismiss: nil)
        }
    }
    
}

extension String {
    
    func attributedText(boldStrings: String..., font: UIFont, boldFontWeight: UIFont.Weight = .semibold) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: self,
                                                         attributes: [NSAttributedString.Key.font: font])
        let boldFontAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: font.pointSize, weight: boldFontWeight)]
        boldStrings.forEach {
            let range = (self as NSString).range(of: $0)
            attributedString.addAttributes(boldFontAttribute, range: range)
        }
        return attributedString
    }
    
}
