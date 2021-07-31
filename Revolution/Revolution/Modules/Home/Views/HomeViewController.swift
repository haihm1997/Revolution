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
        collectionView.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 24, right: 0)
        collectionView.backgroundColor = UIColor.gray
        collectionView.isHidden = true
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.className)
        collectionView.register(HighlightImageCell.self, forCellWithReuseIdentifier: HighlightImageCell.className)
        collectionView.register(HomeHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HomeHeaderView.className)
        return collectionView
    }()
    
    var viewModel = HomeViewModel()
    var homeSections: [HomeSectionType] = []
    
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
        setupCollectionView()
        emptyView.didTapCreateNew.bind(to: didTapGenerateVideo).disposed(by: rx.disposeBag)
    }
    
    private func loadSection() {
        homeSections.removeAll()
        if viewModel.highlightImages.count > 0 {
            homeSections.append(.highlightImage)
        }
        if viewModel.allImages.count > 0 {
            homeSections.append(.allImages)
        }
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
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
        return homeSections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionType = homeSections[section]
        switch sectionType {
        case .highlightImage:
            return 1
        case .allImages:
            return viewModel.allImages.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sectionType = homeSections[indexPath.section]
        switch sectionType {
        case .highlightImage:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HighlightImageCell.className, for: indexPath) as! HighlightImageCell
            cell.bind(images: viewModel.highlightImages)
            return cell
        case .allImages:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.className, for: indexPath) as! ImageCell
            let item = viewModel.allImages[indexPath.row]
            cell.bind(image: item)
            return cell
        }
    }
    
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                         withReuseIdentifier: HomeHeaderView.className,
                                                                         for: indexPath) as! HomeHeaderView
            header.bind(title: "Tất cả ảnh")
            return header
        default:
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let section = homeSections[indexPath.section]
        switch section {
        case .highlightImage:
            return CGSize(width: Constant.Size.screenWidth, height: 200)
        default:
            let imageWidth = (Constant.Size.screenWidth - 16) / 3.0
            return CGSize(width: imageWidth, height: imageWidth)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let section = homeSections[section]
        switch section {
        case .highlightImage:
            return CGSize(width: Constant.Size.screenWidth, height: 0)
        default:
            return CGSize(width: Constant.Size.screenWidth, height: 40)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let section = homeSections[section]
        switch section {
        case .highlightImage:
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        default:
            return UIEdgeInsets(top: 4, left: 4, bottom: 56, right: 4)
        }
    }
    
}

extension HomeViewController {
    
    var contentVisibilityBinder: Binder<Bool> {
        return Binder(self) { target, hasData in
            target.emptyView.isHidden = hasData
            target.collectionView.isHidden = !target.emptyView.isHidden
        }
    }
    
    var didTapGenerateVideo: Binder<Void> {
        return Binder(self) { target, _ in
            let vc = GenerateVideoViewController()
            let sheet = SheetViewController(controller: vc, sizes: [.marginFromTop(Constant.SafeArea.topPadding)], options: nil)
            sheet.pullBarBackgroundColor = .clear
            sheet.dismissOnPull = false
            sheet.didDismiss = { _ in
                print("Did dismiss")
            }
            target.present(sheet, animated: false, completion: nil)
        }
    }
    
}
