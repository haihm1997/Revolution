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
        collectionView.register(HomeHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HomeHeaderView.className)
        return collectionView
    }()
    
    var viewModel: HomeViewModel!
//    private typealias DataSource = RxCollectionViewSectionedReloadDataSource<HomeSection>
//    private lazy var dataSource = self.createDataSource()
    
    override func loadView() {
        super.loadView()
        self.view.backgroundColor = .white
        self.view.addSubviews(navigationView, collectionView, emptyView)
        
        navigationView.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
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
//        configSubViews()
//        bind()
    }
    
//    private func configSubViews() {
//        let scaningItem = HeaderItem(icon: UIImage(name: .scaning)) { [weak self] _ in
//            self?.viewModel.didTapScanProduct.onNext(())
//        }
//        seachHeaderView.addRightItem(scaningItem)
//    }
//
//    private func bind() {
//        viewModel.outSections.map { $0.count > 0 }.bind(to: contentVisibilityBinder).disposed(by: rx.disposeBag)
//        collectionView.rx.setDelegate(self).disposed(by: rx.disposeBag)
//        viewModel.outSections
//            .bind(to: collectionView.rx.items(dataSource: dataSource))
//            .disposed(by: rx.disposeBag)
//        viewModel.outError.bind(to: ErrorHandler.defaultAlertBinder(from: self)).disposed(by: rx.disposeBag)
//        viewModel.outActivity.bind(to: loadingBinder).disposed(by: rx.disposeBag)
//        viewModel.outRevenue.bind(to: revenueView.totalRevenue).disposed(by: rx.disposeBag)
//        searchButton.rx.tap
//            .bind(to: viewModel.outOpenProductList)
//            .disposed(by: rx.disposeBag)
//    }
//
//    private func createDataSource() -> DataSource {
//        let dataSource = DataSource (configureCell: { [weak self] (dataSource, collectionView, indexPath, section) -> UICollectionViewCell in
//            guard let self = self else { return UICollectionViewCell() }
//            let headerType = dataSource[indexPath.section].header
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeSectionIdentifier.identifider(for: headerType).rawValue,
//                                                          for: indexPath)
//            switch headerType {
//            case .draff:
//                let draffOrderCell = cell as! DraffOrderSection
//                draffOrderCell.bind(section.data)
//                draffOrderCell.didTapOrder
//                    .bind(to: self.viewModel.didTapDraffOrder)
//                    .disposed(by: draffOrderCell.disposeBag)
//            case .waitingForPayment:
//                let waitingPaymentCell = cell as! WaitingForPaymentSection
//                waitingPaymentCell.bind(section.data)
//                waitingPaymentCell.didTapPayNow
//                    .bind(to: self.viewModel.didTapPayNow)
//                    .disposed(by: waitingPaymentCell.disposeBag)
//                waitingPaymentCell.didTapCopy
//                    .bind(to: self.copyOrderCodeBinder)
//                    .disposed(by: waitingPaymentCell.disposeBag)
//                waitingPaymentCell.didTapOrder
//                    .bind(to: self.viewModel.outOpenOrderDetail)
//                    .disposed(by: waitingPaymentCell.disposeBag)
//            }
//            return cell
//        })
//
//        dataSource.configureSupplementaryView = { (dataSource, collectionView, kind, indexPath) -> UICollectionReusableView in
//            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HomeHeaderView.className,
//                                                                         for: indexPath) as! HomeHeaderView
//            let headerType = dataSource[indexPath.section].header
//            switch headerType {
//            case .draff(let title):
//                header.bind(title: title, hasViewMore: false)
//            case .waitingForPayment(let title):
//                header.bind(title: title, hasViewMore: true)
//                header.viewMoreButton.rx.controlEvent(.touchUpInside)
//                    .bind(to: self.viewModel.outOpenOrderList)
//                    .disposed(by: header.disposeBag)
//            }
//            return header
//        }
//
//        return dataSource
//    }
    
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let headerType = dataSource[indexPath.section].header
//        return CGSize(width: collectionView.bounds.width, height: HomeSectionIdentifier.identifider(for: headerType).cellHeight)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        return CGSize(width: collectionView.bounds.width, height: 30)
//    }
}

extension HomeViewController {
    
    var contentVisibilityBinder: Binder<Bool> {
        return Binder(self) { target, hasData in
            target.emptyView.isHidden = hasData
            target.collectionView.isHidden = !target.emptyView.isHidden
        }
    }
    
}
