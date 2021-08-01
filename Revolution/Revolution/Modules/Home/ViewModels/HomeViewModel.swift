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
    
    var allVideos = BehaviorRelay<[YMVideo]>(value: [])
    let realmManager = RealmManager.shared
    let didTapRemoveItem = PublishRelay<YMVideo>()
    let outDidRemoveItem = PublishRelay<Bool>()
    
    override init() {
        super.init()
        allVideos.accept(realmManager.getObjects(from: RealmVideo.self).map { $0.toYMVideo() })
        didTapRemoveItem.subscribe(onNext: { [weak self] item in
            var tempResult = self?.allVideos.value ?? []
            if let index = tempResult.firstIndex(where: { $0.id == item.id }) {
                tempResult.remove(at: index)
            }
            self?.realmManager.deleteObject(with: item.original, completion: { _ in
                self?.outDidRemoveItem.accept(true)
                self?.allVideos.accept(tempResult)
            })
        }).disposed(by: rx.disposeBag)
    }
    
    
    
}
