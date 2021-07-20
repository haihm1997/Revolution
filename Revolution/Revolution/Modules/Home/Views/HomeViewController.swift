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
import YPImagePicker
import ZLImageEditor

class HomeViewController: BaseViewController {
    
    let openPickerButton = configure(UIButton()) {
        $0.setTitle("Mở Picker", for: .normal)
        $0.setTitleColor(.blue, for: .normal)
    }
    
    override func loadView() {
        super.loadView()
        self.view.addSubviews(openPickerButton)
        openPickerButton.snp.makeConstraints { maker in
            maker.centerX.centerY.equalToSuperview()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        bind()
    }
    
    private func bind() {
        openPickerButton.rx.tap.bind(to: openPickerBinder).disposed(by: rx.disposeBag)
    }
    
}

extension HomeViewController {
    
    var openPickerBinder: Binder<Void> {
        return Binder(self) { targer, _ in
            let config = targer.configCamera()
            let picker = YPImagePicker(configuration: config)
            picker.didFinishPicking { items, isSuccess in
                guard let modifiedImage = items.singlePhoto?.image else { return }
                picker.dismiss(animated: true) {
                    ZLImageEditorConfiguration.default().editImageTools = [.draw, .clip, .imageSticker, .textSticker, .mosaic, .filter]
                    ZLEditImageViewController.showEditImageVC(parentVC: self, image: modifiedImage, editModel: nil) { [weak self] (resImage, editModel) in
                        print("image modified!")
                    }
                }
            }
            self.present(picker, animated: true, completion: nil)
        }
    }
    
    private func configCamera() -> YPImagePickerConfiguration {
        var config = YPImagePickerConfiguration()
        config.isScrollToChangeModesEnabled = true
        config.onlySquareImagesFromCamera = true
        config.usesFrontCamera = false
        config.showsPhotoFilters = true
        config.showsVideoTrimmer = true
        config.shouldSaveNewPicturesToAlbum = true
        config.albumName = "DefaultYPImagePickerAlbumName"
        config.startOnScreen = YPPickerScreen.photo
        config.screens = [.library, .photo]
        config.showsCrop = .none
        config.targetImageSize = YPImageSize.original
        config.overlayView = UIView()
        config.hidesStatusBar = true
        config.hidesBottomBar = false
        config.hidesCancelButton = false
        config.preferredStatusBarStyle = UIStatusBarStyle.default
        config.maxCameraZoomFactor = 1.0
        
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
    
        return config
    }
    
}


