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
    
    let viewModel = StickerViewModel()
    
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
