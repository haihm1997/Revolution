//
//  GenerateVideoViewModel.swift
//  Revolution
//
//  Created by Hai IT. Hoang Minh on 29/07/2021.
//  Copyright © 2021 TonyHoang. All rights reserved.
//

import UIKit
import RxSwift
import SwiftVideoGenerator
import RxRelay


struct YMSelectedPhoto {
    let isOpenGalleryImage: Bool
    let image: UIImage?
}

class GenerateVideoViewModel: BaseViewModel {
    
    var isSelectedImage = false
    var selectedPhotos: [YMSelectedPhoto] = [YMSelectedPhoto(isOpenGalleryImage: true,
                                                             image: UIImage(name: .icSelectPhoto))]
    var selectedAudios: [AudioModel] = [AudioModel(name: "Audio 1", orinalName: "audio1",  isSelected: true),
                                        AudioModel(name: "Audio 2", orinalName: "audio2", isSelected: false),
                                        AudioModel(name: "Audio 3", orinalName: "audio3", isSelected: false),
                                        AudioModel(name: "Audio 4", orinalName: "audio4", isSelected: false)]
    let didFinishGenerating = PublishSubject<String>()
    
    func generateVideo() {
        guard let selectedAudio = self.selectedAudios.first(where: { $0.isSelected }) else {
            didFinishGenerating.onError(RevolutionError.generateVideoFailed)
            return
        }
        let selectedImages = self.selectedPhotos.filter { !$0.isOpenGalleryImage }
        if let audio = Bundle.main.url(forResource: selectedAudio.orinalName, withExtension: "mp3") {
            VideoGenerator.fileName = UUID().uuidString
            VideoGenerator.shouldOptimiseImageForVideo = true
            
            VideoGenerator.current.generate(withImages: selectedImages.compactMap { $0.image },
                                            andAudios: [audio],
                                            andType: .single, { (progress) in
                print("generateSingleVideoButtonClickHandler: \(progress)")
            }) { [weak self] (result) in
                switch result {
                case .success(let url):
                    print(url)
                    self?.didFinishGenerating.onNext("Tạo video thành công!")
                case .failure(let error):
                    print(error)
                    self?.didFinishGenerating.onError(RevolutionError.generateVideoFailed)
                }
            }
        } else {
            didFinishGenerating.onError(RevolutionError.generateVideoFailed)
        }
    }

}
