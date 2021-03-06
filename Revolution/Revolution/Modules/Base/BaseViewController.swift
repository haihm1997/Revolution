//
//  BaseViewController.swift
//  BaseMVVM
//
//  Created by Hoang Hai on 12/04/2021.
//  Copyright © 2021 TonyHoang. All rights reserved.
//

import UIKit
import RxCocoa
import MBProgressHUD

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
    }
    
}

extension BaseViewController {
    
    var loadingBinder: Binder<Bool> {
        return Binder(self) { (target, isLoading) in
            if isLoading {
                MBProgressHUD.showAdded(to: target.view, animated: true)
            } else {
                MBProgressHUD.hide(for: target.view, animated: true)
            }
        }
    }
    
    func showLoadingIndicator() {
        MBProgressHUD.showAdded(to: view, animated: true)
    }
    
    func hideLoadingIndicator() {
        MBProgressHUD.showAdded(to: view, animated: true)
    }
    
}
