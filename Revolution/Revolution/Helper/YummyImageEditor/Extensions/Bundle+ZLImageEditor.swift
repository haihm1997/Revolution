//
//  HomeViewController.swift
//  Revolution
//
//  Created by Hoang Hai on 19/07/2021.
//  Copyright © 2021 TonyHoang. All rights reserved.
//

import Foundation

private class BundleFinder {}

extension Bundle {
    
    private static var bundle: Bundle? = nil
    
    static var normal_module: Bundle? = {
        let bundleName = "ZLImageEditor"

        var candidates = [
            // Bundle should be present here when the package is linked into an App.
            Bundle.main.resourceURL,

            // Bundle should be present here when the package is linked into a framework.
            Bundle(for: ZLEditImageViewController.self).resourceURL,

            // For command-line tools.
            Bundle.main.bundleURL,
        ]
        
        #if SWIFT_PACKAGE
        // For SWIFT_PACKAGE.
        candidates.append(Bundle.module.bundleURL)
        #endif

        for candidate in candidates {
            let bundlePath = candidate?.appendingPathComponent(bundleName + ".bundle")
            if let bundle = bundlePath.flatMap(Bundle.init(url:)) {
                return bundle
            }
        }
        
        return nil
    }()
    
    static var spm_module: Bundle? = {
        let bundleName = "ZLImageEditor_ZLImageEditor"

        let candidates = [
            // Bundle should be present here when the package is linked into an App.
            Bundle.main.resourceURL,

            // Bundle should be present here when the package is linked into a framework.
            Bundle(for: BundleFinder.self).resourceURL,

            // For command-line tools.
            Bundle.main.bundleURL,
        ]

        for candidate in candidates {
            let bundlePath = candidate?.appendingPathComponent(bundleName + ".bundle")
            if let bundle = bundlePath.flatMap(Bundle.init(url:)) {
                return bundle
            }
        }
        
        return nil
    }()
    
    static var zlImageEditorBundle: Bundle? {
        return normal_module ?? spm_module
    }
    
    class func resetLanguage() {
        self.bundle = nil
    }
    
    class func zlLocalizedString(_ key: String) -> String {
        if self.bundle == nil {
            guard let path = Bundle.zlImageEditorBundle?.path(forResource: self.getLanguage(), ofType: "lproj") else {
                return ""
            }
            self.bundle = Bundle(path: path)
        }
        
        let value = self.bundle?.localizedString(forKey: key, value: nil, table: nil)
        return Bundle.main.localizedString(forKey: key, value: value, table: nil)
    }
    
    private class func getLanguage() -> String {
        var language = "en"
        
        switch ZLImageEditorConfiguration.default().languageType {
        case .system:
            language = Locale.preferredLanguages.first ?? "en"
            
            if language.hasPrefix("zh") {
                if language.range(of: "Hans") != nil {
                    language = "zh-Hans"
                } else {
                    language = "zh-Hant"
                }
            } else if language.hasPrefix("ja") {
                language = "ja-US"
            } else if language.hasPrefix("fr") {
                language = "fr"
            } else if language.hasPrefix("de") {
                language = "de"
            } else if language.hasPrefix("ru") {
                language = "ru"
            } else if language.hasPrefix("vi") {
                language = "vi"
            } else if language.hasPrefix("ko") {
                language = "ko"
            } else if language.hasPrefix("ms") {
                language = "ms"
            } else if language.hasPrefix("it") {
                language = "it"
            } else {
                language = "en"
            }
        case .chineseSimplified:
            language = "zh-Hans"
        case .chineseTraditional:
            language = "zh-Hant"
        case .english:
            language = "en"
        case .japanese:
            language = "ja-US"
        case .french:
            language = "fr"
        case .german:
            language = "de"
        case .russian:
            language = "ru"
        case .vietnamese:
            language = "vi"
        case .korean:
            language = "ko"
        case .malay:
            language = "ms"
        case .italian:
            language = "it"
        }
        
        return language
    }
    
    
}
