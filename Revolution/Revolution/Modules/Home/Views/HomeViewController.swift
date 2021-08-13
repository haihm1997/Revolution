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
import RxSwift
import AVKit
import BSImagePicker
import Photos

class HomeViewController: BaseViewController {
    
    let bannerImage = configure(UIImageView()) {
        $0.image = UIImage(name: .basic)
        $0.backgroundColor = .clear
        $0.contentMode = .scaleToFill
    }
    
    let chooseFontLabel = configure(UILabel()) {
        $0.textColor = .white
        $0.textAlignment = .center
        $0.text = "Chọn phông chữ"
        $0.font = UIFont.systemFont(ofSize: 21, weight: .semibold)
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.contentInset = UIEdgeInsets(top: 8, left: 8, bottom: 24, right: 8)
        collectionView.backgroundColor = UIColor.clear
        collectionView.isHidden = false
        collectionView.register(FontPreviewCell.self, forCellWithReuseIdentifier: FontPreviewCell.className)
        return collectionView
    }()

    
    var viewModel = HomeViewModel()
    
    override func loadView() {
        super.loadView()
        self.view.backgroundColor = .defaultCollectionBackground
        
        self.view.addSubviews(bannerImage, collectionView)
        
        bannerImage.snp.makeConstraints { maker in
            maker.top.leading.trailing.equalToSuperview()
            maker.height.equalTo(Constant.Size.screenWidth * 0.56)
        }
        
//        chooseFontLabel.snp.makeConstraints { maker  in
//            maker.top.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(8)
//            maker.centerX.equalToSuperview()
//        }
//
        collectionView.snp.makeConstraints { maker in
            maker.top.leading.trailing.bottom.equalToSuperview()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        bindViewModel()
    }
    
    private func bindViewModel() {
        viewModel.outAllFonts.bind(to: collectionView.rx.items(cellIdentifier: FontPreviewCell.className, cellType: FontPreviewCell.self)) { row, element, cell in
            if row < 20 {
                cell.bind(data: element, state: .basic)
            } else {
                cell.bind(data: element, state: .premium)
            }
        }.disposed(by: rx.disposeBag)
        
        collectionView.rx.modelSelected(YummyFont.self).bind(to: didChooseFont).disposed(by: rx.disposeBag)
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
        let imageWidth = (Constant.Size.screenWidth - 28) / 2
        return CGSize(width: imageWidth, height: 12 + imageWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
}

extension HomeViewController {
    
    var didChooseFont: Binder<YummyFont> {
        return Binder(self) { target, font in
            let imagePicker = ImagePickerController()
            Settings.shared.selection.max = 1
            target.presentImagePicker(imagePicker) { asset in
                ()
            } deselect: { asset in
                ()
            } cancel: { assets in
                ()
            } finish: { assets in
                guard let asset = assets.first else { return }
                PHImageManager.default().requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFit, options: nil) { (image, info) in
                    target.openEditScreen(image: image, font: font)
                }
            }
        }
    }
    
    private func openEditScreen(image: UIImage?, font: YummyFont) {
        guard let image = image else { return }
        let stickerVC = StickerViewController()
        let stickerVM = StickerViewModel(image: image, selectedFont: font)
        stickerVC.viewModel = stickerVM
        presentPanModal(stickerVC)
    }
    
}

