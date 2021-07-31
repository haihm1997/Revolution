//
//  HighlightImageCell.swift
//  Revolution
//
//  Created by Hoang Hai on 22/07/2021.
//  Copyright © 2021 TonyHoang. All rights reserved.
//

import UIKit
import FSPagerView

class HighlightImageCell: BaseCollectionViewCell {
    
    let pagerView: FSPagerView = {
        let pagerView = FSPagerView()
        pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: FSPagerViewCell.className)
        return pagerView
    }()
    
    let pageControl = FSPageControl()
    var images: [UIImage] = []
    
    override func setupViews() {
        super.setupViews()
        self.contentView.addSubviews(pagerView, pageControl)
        
        pagerView.snp.makeConstraints { maker in
            maker.leading.trailing.top.bottom.equalToSuperview()
        }
        
        pagerView.snp.makeConstraints { maker in
            maker.bottom.equalToSuperview().inset(8)
            maker.centerX.equalToSuperview()
        }
        
        configPagerView()
    }
    
    private func configPagerView() {
        pagerView.dataSource = self
        pagerView.delegate = self
    }
    
    func bind(images: [UIImage]) {
        self.images = images
        pagerView.reloadData()
        pageControl.numberOfPages = images.count
    }
}

extension HighlightImageCell: FSPagerViewDataSource {
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return images.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: FSPagerViewCell.className, at: index)
        cell.imageView?.image = self.images[index]
        cell.imageView?.contentMode = .scaleAspectFill
        cell.imageView?.clipsToBounds = true
        cell.textLabel?.text = index.description+index.description
        return cell
    }
    
}

extension HighlightImageCell: FSPagerViewDelegate {
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        
    }
    
//    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
//        pagerView.deselectItem(at: index, animated: true)
//        pagerView.scrollToItem(at: index, animated: true)
//    }
    
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        self.pageControl.currentPage = targetIndex
    }
    
    func pagerViewDidEndScrollAnimation(_ pagerView: FSPagerView) {
        self.pageControl.currentPage = pagerView.currentIndex
    }
    
}
