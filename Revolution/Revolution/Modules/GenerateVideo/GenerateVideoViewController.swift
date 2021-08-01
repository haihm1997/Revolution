//
//  GenerateVideoViewController.swift
//  Revolution
//
//  Created by Hai IT. Hoang Minh on 29/07/2021.
//  Copyright © 2021 TonyHoang. All rights reserved.
//

import UIKit
import BSImagePicker
import SnapKit
import Photos
import RxCocoa

class GenerateVideoViewController: BaseViewController {
    
    let headerView = BottomSheetHeaderView()
    var generateVideoHandler: ((_ video: RealmVideo) -> Void)?
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.className)
        collectionView.register(SelectAudioCell.self, forCellWithReuseIdentifier: SelectAudioCell.className)
        collectionView.register(SelectImageCell.self, forCellWithReuseIdentifier: SelectImageCell.className)
        collectionView.register(HomeHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HomeHeaderView.className)
        return collectionView
    }()
    
    let generateVideoButton = configure(UIButton()) {
        $0.setTitle("Tạo video", for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        $0.backgroundColor = .primary
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 4
    }
    
    let viewModel = GenerateVideoViewModel()
    
    override func loadView() {
        super.loadView()
        self.view.backgroundColor = .white
        self.view.addSubviews(headerView, generateVideoButton, collectionView)
        
        headerView.snp.makeConstraints { maker in
            maker.top.equalToSuperview()
            maker.leading.trailing.equalToSuperview()
            maker.height.equalTo(52)
        }
        
        generateVideoButton.snp.makeConstraints { maker in
            maker.height.equalTo(42)
            maker.leading.trailing.equalToSuperview().inset(24)
            maker.bottom.equalToSuperview().inset(Constant.SafeArea.bottomPadding + 12)
        }
        
        collectionView.snp.makeConstraints { maker in
            maker.top.equalTo(headerView.snp.bottom)
            maker.leading.trailing.equalToSuperview()
            maker.bottom.equalToSuperview().inset(Constant.SafeArea.bottomPadding + 62)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerView.title = "Tạo mới video"
        collectionView.dataSource = self
        collectionView.delegate = self
        
        headerView.didTapLeftButton = {
            self.dismiss(animated: true, completion: nil)
        }
        
        generateVideoButton.rx.tap.bind(to: didTapGenerate).disposed(by: rx.disposeBag)
        viewModel.didFinishGenerating.subscribe(onNext: { [weak self] video in
            guard let self = self else { return }
            self.hideLoadingIndicator()
            ErrorHandler.showDefaultAlert(message: "Tạo video thành công", from: self) {
                self.dismiss(animated: true) {
                    self.generateVideoHandler?(video)
                }
            }
        }) { [weak self] error in
            guard let self = self else { return }
            self.hideLoadingIndicator()
            ErrorHandler.showDefaultAlert(message: error.localizedDescription, from: self) {
                self.viewModel.selectedPhotos = [YMSelectedPhoto(isOpenGalleryImage: true,
                                                                image: UIImage(name: .icSelectPhoto))]
                self.collectionView.reloadData()
            }
        }.disposed(by: rx.disposeBag)
    }
    
    var didTapGenerate: Binder<Void> {
        return Binder(self) { target, _ in
            target.showLoadingIndicator()
            target.viewModel.generateVideo()
        }
    }
    
}

extension GenerateVideoViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return viewModel.selectedPhotos.count
        default:
            return viewModel.selectedAudios.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let item = viewModel.selectedPhotos[indexPath.row]
            guard !item.isOpenGalleryImage else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelectImageCell.className, for: indexPath) as! SelectImageCell
                cell.bind(image: item.image)
                return cell
            }
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.className, for: indexPath) as! ImageCell
            cell.bind(image: item.image)
            cell.indexPath = indexPath
            cell.removeButton.rx.tap.subscribe(onNext: { [weak self] in
                guard let self = self, let indexPath = cell.indexPath else { return }
                self.viewModel.selectedPhotos.remove(at: indexPath.row)
                self.collectionView.reloadData()
            }).disposed(by: cell.disposeBag)
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelectAudioCell.className, for: indexPath) as! SelectAudioCell
            let item = viewModel.selectedAudios[indexPath.row]
            cell.fill(audioModel: item)
            return cell
        }
    }
    
}

extension GenerateVideoViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                         withReuseIdentifier: HomeHeaderView.className,
                                                                         for: indexPath) as! HomeHeaderView
            switch indexPath.section {
            case 0:
                header.bind(title: "Chọn ảnh")
            default:
                header.bind(title: "Chọn âm thanh")
            }
            return header
        default:
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            let width = (Constant.Size.screenWidth - 36) / 3.0
            return CGSize(width: width, height: width)
        default:
            return CGSize(width: Constant.Size.screenWidth, height: 46)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: Constant.Size.screenWidth, height: 52)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch section {
        case 0:
            return UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        default:
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            let image = viewModel.selectedPhotos[indexPath.row]
            if image.isOpenGalleryImage {
                openImagePicker()
            }
        default:
            for i in 0..<viewModel.selectedAudios.count {
                viewModel.selectedAudios[i].isSelected = false
            }
            viewModel.selectedAudios[indexPath.row].isSelected = true
            collectionView.reloadData()
        }
    }
    
    private func openImagePicker() {
        let imagePicker = ImagePickerController()
        imagePicker.settings.selection.max = 6
        imagePicker.settings.theme.selectionStyle = .numbered
        imagePicker.settings.fetch.assets.supportedMediaTypes = [.image]
        var selectedImages: [PHAsset] = []
        presentImagePicker(imagePicker, select: { (asset) in
            selectedImages.append(asset)
        }, deselect: { (asset) in
            if let index = selectedImages.firstIndex(where: { $0 == asset }) {
                selectedImages.remove(at: index)
            }
        }, cancel: { (assets) in
            print("Cancelled")
        }, finish: { [weak self] (assets) in
            var imageModels: [YMSelectedPhoto] = []
            for image in selectedImages {
                imageModels.append(YMSelectedPhoto(isOpenGalleryImage: false, image: image.image))
            }
            self?.viewModel.selectedPhotos.append(contentsOf: imageModels)
            self?.collectionView.reloadData()
        })
    }
    
}
