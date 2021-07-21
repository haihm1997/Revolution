//
//  TabBarView.swift
//  SmartPOS
//
//  Created by Hoang Hai on 10/05/2021.
//  Copyright © 2021 TonyHoang. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class TabBarView: BaseCustomView {
    
    private let homeTabItem = configure(TabBarItemView(frame: TabBarItemView.rect)) {
        $0.icon = YMTabBarItemType.home.icon
        $0.title = YMTabBarItemType.home.title
        $0.tabItemType = .home
    }
    
    private let centerView = UIView(frame: TabBarItemView.rect)
    
    private let profileTabItem = configure(TabBarItemView(frame: TabBarItemView.rect)) {
        $0.icon = YMTabBarItemType.profile.icon
        $0.title = YMTabBarItemType.profile.title
        $0.tabItemType = .profile
    }
    
    private let stackView = configure(UIStackView()) {
        $0.axis = .horizontal
        $0.backgroundColor = .white
        $0.distribution = .fillEqually
    }
    
    var inTabItemTapped = BehaviorRelay<YMTabBarItemType>(value: YMTabBarItemType.home)
    
    override func commonInit() {
        setupViews()
        bind()
        //activeLayout(at: .home)
    }
    
    private func setupViews() {
        backgroundColor = .white
        
        stackView.addArrangedSubviews(homeTabItem, centerView, profileTabItem)
        
        self.addSubview(stackView)
        stackView.snp.makeConstraints { (maker) in
            maker.top.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func bind() {
        inTabItemTapped.bind(to: activeTabItemBinder).disposed(by: rx.disposeBag)
    }
    
    private func activeLayout(at tab: YMTabBarItemType, animated: Bool = false) {
        homeTabItem.active(tab == .home, animated: animated)
        profileTabItem.active(tab == .profile, animated: animated)
    }
    
}

extension TabBarView {
    
    var activeTabItemBinder: Binder<YMTabBarItemType> {
        return Binder(self) { target, itemType in
            target.activeLayout(at: itemType)
        }
    }
    
}
