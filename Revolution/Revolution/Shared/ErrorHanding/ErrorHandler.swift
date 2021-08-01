//
//  ErrorHandler.swift
//  BaseMVVM
//
//  Created by Hoang Hai on 14/04/2021.
//  Copyright © 2021 TonyHoang. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit
import SnapKit

class ErrorHandler {
    
    static func defaultAlertBinder(title: String? = "Notification", from controller: UIViewController) -> Binder<RevolutionError> {
        return Binder(controller) { (target, error) in
            let alert = UIAlertController(title: title, message: error.debugDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { action in
                switch action.style{
                case .default:
                    alert.dismiss(animated: true, completion: nil)
                case .cancel:
                    alert.dismiss(animated: true, completion: nil)
                case .destructive:
                    alert.dismiss(animated: true, completion: nil)
                }
            }))
            target.present(alert, animated: true, completion: nil)
        }
    }
    
    static func showDefaultAlert(message: String, from controller: UIViewController, didDismiss: (() -> Void)?) {
        let alert = UIAlertController(title: "Yummy Photo", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { action in
            switch action.style{
            case .default:
                alert.dismiss(animated: true, completion: didDismiss)
            case .cancel:
                alert.dismiss(animated: true, completion: didDismiss)
            case .destructive:
                alert.dismiss(animated: true, completion: didDismiss)
            }
        }))
        controller.present(alert, animated: true, completion: nil)
    }
    
    static func show2OptionAlert(message: String, from controller: UIViewController, didDismiss: (() -> Void)?, didOk: (() -> Void)?) {
        let alert = UIAlertController(title: "Yummy Photo", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { _ in
            didOk?()
        }
        let cancelAction = UIAlertAction(title: "Đóng", style: .cancel) { _ in
            didDismiss?()
        }
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        controller.present(alert, animated: true, completion: nil)
    }
    
}

