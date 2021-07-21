//
//  TabBarViewController.swift
//  SmartPOS
//
//  Created by Hoang Hai on 10/05/2021.
//  Copyright © 2021 TonyHoang. All rights reserved.
//

import UIKit
import SnapKit
import RxCocoa
import YPImagePicker
import ZLImageEditor

enum YMTabBarItemType: Int, CaseIterable {
    case home = 0
    case addPhoto = 1
    case profile = 2
    
    var icon: UIImage? {
        switch self {
        case .home:
            return UIImage(name: .tabBarHome)?.withRenderingMode(.alwaysTemplate)
        case .profile:
            return UIImage(name: .tabBarAccount)?.withRenderingMode(.alwaysTemplate)
        case .addPhoto:
            return UIImage(name: .tabBarAddPhoto)?.withRenderingMode(.alwaysTemplate)
        }
    }
    
    var title: String {
        switch self {
        case .home:
            return "Trang chủ"
        case .addPhoto:
            return ""
        case .profile:
            return "Cá nhân"
        }
    }
    
}

class TabBarController: UITabBarController {
    
    let smartPOSTabBar = CustomTabBar()
    
    var viewModel: TabBarViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.isHidden = true
        self.setValue(smartPOSTabBar, forKey: "tabBar")
        self.delegate = self
        self.viewControllers = setupViewControllers()
        
        smartPOSTabBar.outCenterButtonTapped.bind(to: openPickerBinder).disposed(by: rx.disposeBag)
    }
    
    private func setupViewControllers() -> [UIViewController] {
        var controllers: [UIViewController] = []
        
        let homeVC = HomeViewController()
        controllers.append(homeVC)
        
        let emptyVC = UIViewController()
        controllers.append(emptyVC)
        
        let profileVC = ProfileViewController()
        controllers.append(profileVC)
        
        return controllers
    }
    
}

extension TabBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        guard selectedIndex != YMTabBarItemType.addPhoto.rawValue else { return }
        smartPOSTabBar.inTabItemTapped.accept(self.selectedIndex)
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let addOrderIndex = YMTabBarItemType.addPhoto.rawValue
        if viewController == tabBarController.viewControllers?[addOrderIndex] {
            return false
        } else {
            return true
        }
    }
    
}

extension TabBarController {
    
    var openPickerBinder: Binder<Int> {
        return Binder(self) { targer, index in
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
    
        return config
    }
    
}
