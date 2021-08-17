//
//  PremiumRegisterViewController.swift
//  Revolution
//
//  Created by Hai IT. Hoang Minh on 17/08/2021.
//  Copyright © 2021 TonyHoang. All rights reserved.
//

import UIKit
import PanModal
import RxCocoa

class PremiumRegisterViewController: UIViewController {
    
    let containerView = configure(UIView()) {
        $0.backgroundColor = .white
    }
    
    let closeButton = configure(UIButton()) {
        $0.setImage(UIImage(named: "ic_close"), for: .normal)
        $0.backgroundColor = .clear
    }
    
    let titleLabel = configure(UILabel()) {
        $0.text = "Đăng ký Yummy Premium"
        $0.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        $0.textColor = .textPrimary
    }
    
    let lineView = configure(UIView()) {
        $0.backgroundColor = .divided
    }
    
    let premiumImageView = configure(UIImageView()) {
        $0.image = UIImage(named: "ic_premium_large")
        $0.contentMode = .scaleToFill
    }
    
    let contentLabel = configure(UILabel()) {
        let content = "Sẵn sàng để trải nghiệm những tính năng tuyệt vời cùng Yummy Premium.\n \nMiễn phí sử dụng 3 ngày đầu"
        let part = "Miễn phí sử dụng 3 ngày đầu"
        $0.attributedText = content.attributedText(boldStrings: part, font: UIFont.systemFont(ofSize: 15, weight: .regular))
        $0.textColor = .textSecondary
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    
    let registerButton = configure(UIButton()) {
        $0.setTitle("129.000đ / Tuần", for: .normal)
        $0.backgroundColor = .primary
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        $0.layer.cornerRadius = 20
    }
    
    var didTapPurchase: (() -> Void)?
    
    override func loadView() {
        super.loadView()
        containerView.addSubview(closeButton)
        closeButton.snp.makeConstraints { maker in
            maker.width.height.equalTo(32)
            maker.top.leading.equalTo(16)
        }
        
        containerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.top.equalToSuperview().inset(46)
        }
        
        containerView.addSubview(premiumImageView)
        premiumImageView.snp.makeConstraints { maker in
            maker.width.height.equalTo(132)
            maker.centerX.equalToSuperview()
            maker.top.equalTo(titleLabel.snp.bottom).offset(24)
        }
        
        containerView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.top.equalTo(premiumImageView.snp.bottom).offset(16)
            maker.leading.trailing.equalToSuperview().inset(32)
        }
        
        containerView.addSubview(registerButton)
        registerButton.snp.makeConstraints { maker in
            maker.leading.trailing.equalToSuperview().inset(24)
            maker.bottom.equalToSuperview().inset(16 + Constant.SafeArea.bottomPadding)
            maker.height.equalTo(44)
            maker.top.equalTo(contentLabel.snp.bottom).offset(32)
        }
        
        self.view.addSubview(containerView)
        containerView.snp.makeConstraints { maker in
            maker.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerButton.rx.tap.bind(to: didTapPurchaseBinder).disposed(by: rx.disposeBag)
        closeButton.rx.tap.bind(to: didTapCloseBinder).disposed(by: rx.disposeBag)
    }
    
    var didTapPurchaseBinder: Binder<Void> {
        return Binder(self) { target, _ in
            target.didTapPurchase?()
            target.dismiss(animated: true, completion: nil)
        }
    }
    
    var didTapCloseBinder: Binder<Void> {
        return Binder(self) { target, _ in
            target.dismiss(animated: true, completion: nil)
        }
    }
    
}

extension PremiumRegisterViewController: PanModalPresentable {
    
    public var panScrollable: UIScrollView? {
        return nil
    }
    
    public var topOffset: CGFloat {
        return 0
    }
    
    public var longFormHeight: PanModalHeight {
        return .maxHeight
    }
    
    public var panModalBackgroundColor: UIColor {
        return UIColor.black.withAlphaComponent(0.5)
    }
    
    public var showDragIndicator: Bool {
        false
    }
    
}

