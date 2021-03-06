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
import Photos
import YPImagePicker
import Toast_Swift

class HomeViewController: BaseViewController {
    
    let bannerImage = configure(UIImageView()) {
        $0.backgroundColor = .clear
        $0.contentMode = .scaleToFill
    }
    
    let chooseFontLabel = configure(UILabel()) {
        $0.textColor = .white
        $0.textAlignment = .center
        $0.text = "Chọn phông chữ"
        $0.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.contentInset = UIEdgeInsets(top: 24, left: 8, bottom: 24, right: 8)
        collectionView.backgroundColor = UIColor.clear
        collectionView.isHidden = false
        collectionView.register(FontPreviewCell.self, forCellWithReuseIdentifier: FontPreviewCell.className)
        return collectionView
    }()
    
    var viewModel = HomeViewModel()
    
    override func loadView() {
        super.loadView()
        self.view.backgroundColor = .defaultCollectionBackground
        
        self.view.addSubviews(bannerImage, collectionView, chooseFontLabel)
        
        bannerImage.snp.makeConstraints { maker in
            maker.top.leading.trailing.equalToSuperview()
            maker.height.equalTo(Constant.Size.screenWidth * 0.56)
        }
        
        chooseFontLabel.snp.makeConstraints { maker in
            maker.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).inset(16)
            maker.centerX.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints { maker in
            maker.top.equalTo(chooseFontLabel.snp.bottom).offset(16)
            maker.leading.trailing.bottom.equalToSuperview()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let isPurchased = YummyPhotoApplication.shared.isPurchased
        bannerImage.image = isPurchased ? UIImage(name: .premiun) : UIImage(name: .basic)
    }
    
    private func bindViewModel() {
        viewModel.outAllFonts.bind(to: collectionView.rx.items(cellIdentifier: FontPreviewCell.className, cellType: FontPreviewCell.self)) { row, element, cell in
            cell.bind(data: element, state: element.isPremium ? .premium : .basic)
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
    
    private func openPhotoPicker(font: YummyFont) {
        let config = configCamera()
        let picker = YPImagePicker(configuration: config)
        picker.didFinishPicking { [weak self] items, isSuccess in
            guard let modifiedImage = items.singlePhoto?.image else {
                picker.dismiss(animated: true, completion: nil)
                return
            }
            picker.dismiss(animated: true) {
                self?.openEditPhoto(with: modifiedImage, font: font.font)
            }
        }
        self.present(picker, animated: true, completion: nil)
    }
    
    private func configCamera() -> YPImagePickerConfiguration {
        var config = YPImagePickerConfiguration()
        config.albumName = "YummyPhoto"
        config.startOnScreen = YPPickerScreen.photo
        config.screens = [.library]
        config.showsCrop = .none
        config.targetImageSize = YPImageSize.original
        config.overlayView = UIView()
        config.hidesStatusBar = true
        config.hidesBottomBar = false
        config.hidesCancelButton = false
        config.preferredStatusBarStyle = UIStatusBarStyle.default
        config.library.options = nil
        config.library.onlySquare = false
        config.library.isSquareByDefault = true
        config.library.minWidthForItem = nil
        config.library.mediaType = YPlibraryMediaType.photo
        config.library.defaultMultipleSelection = false
        config.library.maxNumberOfItems = 1
        config.library.minNumberOfItems = 1
        config.library.numberOfItemsInRow = 4
        config.library.spacingBetweenItems = 1.0
        config.library.skipSelectionsGallery = false
        config.library.preselectedItems = nil
        
        config.wordings.cancel = "Đóng"
        config.wordings.done = "Xong"
        config.wordings.next = "Tiếp tục"
        config.wordings.ok = "Đồng ý"
        config.wordings.save = "Lưu"
        config.wordings.warningMaxItemsLimit = "Tổng số ảnh và video được chọn không được vượt quá %d"
        config.wordings.permissionPopup.cancel = "Đóng"
        config.wordings.permissionPopup.grantPermission = "Cho phép truy cập"
        config.wordings.permissionPopup.message = "Vui lòng cho phép Yummy Photo truy cập"
        config.wordings.permissionPopup.title = "Truy cập bị từ chối"
        
    
        return config
    }
    
    func openEditPhoto(with image: UIImage, font: UIFont) {
        let isPremium = YummyPhotoApplication.shared.isPurchased
        if isPremium {
            ZLImageEditorConfiguration.default().editImageTools = [.draw, .clip, .imageSticker, .textSticker, .mosaic, .filter]
        } else {
            ZLImageEditorConfiguration.default().editImageTools = [.clip, .mosaic, .filter]
        }
        ZLEditImageViewController.showEditImageVC(parentVC: self, image: image, editModel: nil, font: font) { (resImage, editModel) in
            UIImageWriteToSavedPhotosAlbum(resImage, nil, nil, nil)
            self.view.makeToast("Lưu ảnh thành công!")
        }
    }
    
    var didChooseFont: Binder<YummyFont> {
        return Binder(self) { target, font in
            if font.isPremium {
                if YummyPhotoApplication.shared.isPurchased {
                    target.openPhotoPicker(font: font)
                } else {
                    target.showRequestPurchaseAlert()
                }
            } else {
                target.openPhotoPicker(font: font)
            }
            
        }
    }
    
    private func showRequestPurchaseAlert() {
        ErrorHandler.show2OptionAlert(message: "Bạn cần đăng ký Yummy Premium để sử dụng phông chữ này",
                                      from: self,
                                      didDismiss: nil) { [weak self] in
            guard let tabBarController = self?.tabBarController as? TabBarController else {
                return
            }
            tabBarController.selectedIndex = 2
            tabBarController.smartPOSTabBar.inTabItemTapped.accept(2)
            
        }
    }
    
}

