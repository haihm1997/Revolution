//
//  HomeViewModel.swift
//  Revolution
//
//  Created by Hoang Hai on 19/07/2021.
//  Copyright © 2021 TonyHoang. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay
import Photos

struct YMVideo {
    var url: URL?
    var previewImage: UIImage?
    var id: String
    let original: RealmVideo
    
    init(_ realmVideo: RealmVideo) {
        let videoURL = URL(string: realmVideo.url)
        self.url = videoURL
        if let url = videoURL {
            self.previewImage = Utils.videoPreviewImage(url: url)
        }
        self.id = realmVideo.id
        self.original = realmVideo
    }
}

class HomeViewModel: BaseViewModel {
    
    var images: [UIImage] = []
    let realmManager = RealmManager.shared
    let didTapRemoveItem = PublishRelay<YMVideo>()
    let outDidRemoveItem = PublishRelay<Bool>()
    let outDidFetchImages = PublishRelay<Void>()
    
    
    override init() {
        super.init()
//        allVideos.accept(realmManager.getObjects(from: RealmVideo.self).map { $0.toYMVideo() })
//        didTapRemoveItem.subscribe(onNext: { [weak self] item in
//            var tempResult = self?.allVideos.value ?? []
//            if let index = tempResult.firstIndex(where: { $0.id == item.id }) {
//                tempResult.remove(at: index)
//            }
//            self?.realmManager.deleteObject(with: item.original, completion: { _ in
//                self?.outDidRemoveItem.accept(true)
//                self?.allVideos.accept(tempResult)
//            })
//        }).disposed(by: rx.disposeBag)
    }
    
    func getPhotos() {

        let manager = PHImageManager.default()
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = false
        requestOptions.deliveryMode = .highQualityFormat
        // .highQualityFormat will return better quality photos
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]

        let results: PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        if results.count > 0 {
            for i in 0..<results.count {
                let asset = results.object(at: i)
                let size = CGSize(width: 700, height: 700)
                manager.requestImage(for: asset, targetSize: size, contentMode: .aspectFill, options: requestOptions) { (image, _) in
                    if let image = image {
                        self.images.append(image)
                        self.outDidFetchImages.accept(())
                    } else {
                        print("error asset to image")
                    }
                }
            }
        } else {
            print("no photos to display")
        }

    }
    
    
    
}
