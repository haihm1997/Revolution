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

class HomeViewController: BaseViewController {
    
    let navigationView = configure(MyNavigationView()) {
        $0.title = "Home"
        $0.leftButtonIcon = nil
    }
    
    let emptyView = configure(HomeEmptyView()) {
        $0.isHidden = false
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.contentInset = UIEdgeInsets(top: 8, left: 8, bottom: 24, right: 8)
        collectionView.backgroundColor = UIColor.white
        collectionView.isHidden = true
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
        self.view.addSubviews(navigationView, collectionView, emptyView, addView)
        
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
        
        addView.snp.makeConstraints { maker in
            maker.trailing.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(24)
            maker.width.height.equalTo(60)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        emptyView.didTapCreateNew.bind(to: didTapGenerateVideo).disposed(by: rx.disposeBag)
    }
    
    private func bindViewModel() {
        viewModel.allVideos.bind(to: collectionView.rx.items(cellIdentifier: ImageCell.className,
                                                             cellType: ImageCell.self)) { [weak self] row, element, cell in
            guard let self = self else { return }
            cell.bind(image: element.previewImage)
            cell.removeButton.rx.tap
                .withLatestFrom(Observable.just(element))
                .bind(to: self.didTapRemoveItemBinder)
                .disposed(by: self.rx.disposeBag)
        }.disposed(by: rx.disposeBag)
        viewModel.allVideos.map { $0.count > 0 }.bind(to: contentVisibilityBinder).disposed(by: rx.disposeBag)
        collectionView.delegate = self
        addView.didTapAddButton.bind(to: didTapGenerateVideo).disposed(by: rx.disposeBag)
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

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let imageWidth = (Constant.Size.screenWidth - 38) / 3.0
        return CGSize(width: imageWidth, height: imageWidth)
    }
    
}

extension HomeViewController {
    
    var contentVisibilityBinder: Binder<Bool> {
        return Binder(self) { target, hasData in
            target.collectionView.isHidden = !hasData
            target.emptyView.isHidden = hasData
        }
    }
    
    var didTapGenerateVideo: Binder<Void> {
        return Binder(self) { target, _ in
            let vc = GenerateVideoViewController()
            let sheet = SheetViewController(controller: vc, sizes: [.marginFromTop(Constant.SafeArea.topPadding)], options: nil)
            sheet.pullBarBackgroundColor = .clear
            sheet.dismissOnPull = false
            vc.generateVideoHandler = { [weak self] video in
                guard let self = self else { return }
                var tempVideos = self.viewModel.allVideos.value
                tempVideos.append(YMVideo(video))
                self.viewModel.allVideos.accept(tempVideos)
            }
            target.present(sheet, animated: false, completion: nil)
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
