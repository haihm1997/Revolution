//
//  YummyWebView.swift
//  Revolution
//
//  Created by Hai IT. Hoang Minh on 18/08/2021.
//  Copyright © 2021 TonyHoang. All rights reserved.
//

import UIKit
import WebKit
import RxCocoa

class YummyWebView: BaseViewController {
    
    let closeButton = configure(UIButton()) {
        $0.setImage(UIImage(named: "ic_close"), for: .normal)
        $0.backgroundColor = .clear
    }
    
    let titleLabel = configure(UILabel()) {
        $0.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        $0.textColor = .textPrimary
    }
    
    var urlStr: String = ""
    
    let webView = WKWebView()
    
    override func loadView() {
        super.loadView()
        
        self.view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).inset(16)
        }
        
        self.view.addSubview(closeButton)
        closeButton.snp.makeConstraints { maker in
            maker.width.height.equalTo(32)
            maker.leading.equalTo(16)
            maker.centerY.equalTo(titleLabel.snp.centerY)
        }
        
        self.view.addSubview(webView)
        webView.snp.makeConstraints { maker in
            maker.top.equalTo(titleLabel.snp.bottom).offset(16)
            maker.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        titleLabel.text = title
        let url = URL(string: urlStr)!
        webView.load(URLRequest(url: url))
        
        closeButton.rx.tap.bind(to: didTapClose).disposed(by: rx.disposeBag)
    }
    
    var didTapClose: Binder<Void> {
        return Binder(self) { target, _ in
            target.dismiss(animated: true, completion: nil)
        }
    }
    
}
