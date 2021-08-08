//
//  AppDelegate.swift
//  Revolution
//
//  Created by TonyHoang on 19/07/2021.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = TabBarController()
        window.makeKeyAndVisible()
        self.window = window
    
        YummyPhotoApplication.shared.appDidFinishLaunching()
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        IAPManager.shared.stopObserving()
    }

}

