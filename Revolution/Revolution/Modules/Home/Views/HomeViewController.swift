//
//  HomeViewController.swift
//  Revolution
//
//  Created by Hoang Hai on 19/07/2021.
//  Copyright © 2021 TonyHoang. All rights reserved.
//

import UIKit
import SnapKit
import RxCocoa
import RxDataSources
import FittedSheets
import RxSwift
import AVKit

class HomeViewController: BaseViewController {
    
    let navigationView = configure(MyNavigationView()) {
        $0.title = "Home"
        $0.leftButtonIcon = nil
    }
    
    let emptyView = configure(HomeEmptyView()) {
        $0.isHidden = true
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.contentInset = UIEdgeInsets(top: 8, left: 8, bottom: 24, right: 8)
        collectionView.backgroundColor = UIColor.white
        collectionView.isHidden = false
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.className)
        collectionView.register(HighlightImageCell.self, forCellWithReuseIdentifier: HighlightImageCell.className)
        collectionView.register(HomeHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HomeHeaderView.className)
        return collectionView
    }()
    
    let addView = AddView()
    
    var viewModel = HomeViewModel()
    
    override func loadView() {
        super.loadView()
        self.view.backgroundColor = .white
        self.view.addSubviews(navigationView, collectionView, emptyView)
        
        navigationView.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview()
            maker.leading.trailing.equalToSuperview()
            maker.height.equalTo(Constant.NavigationSize.totalHeight)
        }

        collectionView.snp.makeConstraints { (maker) in
            maker.top.equalTo(navigationView.snp.bottom)
            maker.leading.trailing.bottom.equalToSuperview()
        }

        emptyView.snp.makeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.centerY.equalToSuperview()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
//        viewModel.getPhotos()
    }
    
    private func bindViewModel() {
        collectionView.delegate = self
        collectionView.dataSource = self
//        addView.didTapAddButton.bind(to: didTapGenerateVideo).disposed(by: rx.disposeBag)
        viewModel.outDidFetchImages.bind(to: didFetchImageBinder).disposed(by: rx.disposeBag)
    }
    
    private func createAlertView(message: String?) {
        let messageAlertController = UIAlertController(title: "Yummy Photo", message: message, preferredStyle: .alert)
        messageAlertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
            messageAlertController.dismiss(animated: true, completion: nil)
        }))
        DispatchQueue.main.async { [weak self] in
            self?.present(messageAlertController, animated: true, completion: nil)
        }
    }
    
}

extension HomeViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.className, for: indexPath) as! ImageCell
        cell.bind(image: viewModel.images[indexPath.row])
        return cell
    }
    
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let imageWidth = (Constant.Size.screenWidth - 38) / 3.0
        return CGSize(width: imageWidth, height: imageWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
}

extension HomeViewController {
    
    var contentVisibilityBinder: Binder<Bool> {
        return Binder(self) { target, hasData in
            target.collectionView.isHidden = !hasData
            target.emptyView.isHidden = hasData
        }
    }
    
    var didFetchImageBinder: Binder<Void> {
        return Binder(self) { target, _ in
            target.collectionView.reloadData()
        }
    }
    
    var didRemoveItemBinder: Binder<Void> {
        return Binder(self) { target, _ in
            ErrorHandler.showDefaultAlert(message: "Đã xoá video", from: target, didDismiss: nil)
        }
    }
    
    var didTapRemoveItemBinder: Binder<YMVideo> {
        return Binder(self) { target, item in
            ErrorHandler.show2OptionAlert(message: "Bạn có muốn xoá video?", from: self, didDismiss: nil) {
                target.viewModel.didTapRemoveItem.accept(item)
            }
        }
    }
    
}
