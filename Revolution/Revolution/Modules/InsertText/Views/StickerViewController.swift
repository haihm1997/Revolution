//
//  StickerViewController.swift
//  Revolution
//
//  Created by Hai IT. Hoang Minh on 09/08/2021.
//  Copyright © 2021 TonyHoang. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import PanModal

class StickerViewController: BaseViewController {
    
    var viewModel: StickerViewModel!
    
    let stickerView = JLStickerImageView()
    
    let topToolBar = configure(UIView()) {
        $0.backgroundColor = .white
    }
    
    let bottomToolBar = configure(UIView()) {
        $0.backgroundColor = .white
    }
    
    let closeButton = configure(UIButton()) {
        $0.setImage(UIImage(name: .icClose), for: .normal)
    }
    
    let saveButton = configure(UIButton()) {
        $0.setTitle("Lưu", for: .normal)
    }
    
    let addButton = configure(UIButton()) {
        $0.setTitle("Thêm", for: .normal)
    }
    
    override func loadView() {
        super.loadView()
        
        topToolBar.addSubviews(closeButton, saveButton, bottomToolBar)
        closeButton.snp.makeConstraints { maker in
            maker.leading.equalToSuperview().inset(8)
            maker.width.height.equalTo(26)
            maker.centerY.equalToSuperview()
        }
        
        bottomToolBar.addSubviews(addButton)
        addButton.snp.makeConstraints { maker in
            maker.trailing.equalToSuperview().inset(8)
            maker.centerY.equalToSuperview()
            maker.width.equalTo(60)
        }
        
        saveButton.snp.makeConstraints { maker in
            maker.trailing.equalToSuperview().inset(8)
            maker.centerY.equalToSuperview()
            maker.width.equalTo(60)
        }
        
        view.addSubviews(topToolBar, stickerView, bottomToolBar)
        
        bottomToolBar.snp.makeConstraints { maker in
            maker.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            maker.height.equalTo(50)
            maker.leading.trailing.equalToSuperview()
        }
        
        topToolBar.snp.makeConstraints { maker in
            maker.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            maker.height.equalTo(50)
            maker.leading.trailing.equalToSuperview()
        }
        
        stickerView.snp.makeConstraints { maker in
            maker.leading.trailing.equalToSuperview()
            maker.top.equalTo(topToolBar.snp.bottom)
            maker.bottom.equalTo(bottomToolBar.snp.top)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stickerView.image = viewModel.selectedImage
        stickerView.fontName = viewModel.selectedFont.name
        
        bind()
    }
    
    private func bind() {
        addButton.rx.tap.bind(to: didTapAddButotn).disposed(by: rx.disposeBag)
        saveButton.rx.tap.bind(to: didTapSaveButton).disposed(by: rx.disposeBag)
        closeButton.rx.tap.bind(to: didTapCloseButton).disposed(by: rx.disposeBag)
    }
    
}

extension StickerViewController {
    
    var didTapSaveButton: Binder<Void> {
        return Binder(self) { target, _ in
            let image = target.stickerView.renderContentOnView()
            UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
        }
    }
    
    var didTapAddButotn: Binder<Void> {
        return Binder(self) { target, _ in
            target.stickerView.addLabel()
            
            target.stickerView.textColor = UIColor.white
            target.stickerView.textAlpha = 1
            target.stickerView.currentlyEditingLabel.closeView!.image = UIImage(named: "cancel")
            target.stickerView.currentlyEditingLabel.rotateView?.image = UIImage(named: "rotate-option")
            target.stickerView.currentlyEditingLabel.border?.strokeColor = UIColor.white.cgColor
            target.stickerView.currentlyEditingLabel.labelTextView?.font = target.viewModel.selectedFont.font
            target.stickerView.currentlyEditingLabel.labelTextView?.becomeFirstResponder()
        }
    }
    
    var didTapCloseButton: Binder<Void> {
        return Binder(self) { target, _ in
            target.dismiss(animated: true, completion: nil)
        }
    }
    
}

extension StickerViewController: PanModalPresentable {
    
    public var panScrollable: UIScrollView? {
        return nil
    }
    
    public var topOffset: CGFloat {
        return 0
    }
    
    public var longFormHeight: PanModalHeight {
        return .maxHeight
    }
    
    public var panModalBackgroundColor: UIColor {
        return UIColor.black.withAlphaComponent(0.5)
    }
    
    public var showDragIndicator: Bool {
        false
    }
    
}
