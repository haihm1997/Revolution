//
//  View+.swift
//  BaseMVVM
//
//  Created by Hoang Hai on 9/19/20.
//  Copyright © 2020 TonyHoang. All rights reserved.
//

import UIKit

extension UIView {
    
    static func configure<T>(
        _ value: T,
        using closure: (inout T) throws -> Void
    ) rethrows -> T {
        var value = value
        try closure(&value)
        return value
    }
    
    func addSubviews<S: Sequence>(_ subviews: S) where S.Iterator.Element: UIView {
        subviews.forEach(self.addSubview(_:))
    }
    
    func addSubviews(_ subviews: UIView...) {
        self.addSubviews(subviews)
    }
    
    func removeAllSubviews() {
        self.subviews.forEach { $0.removeFromSuperview() }
    }
    
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}
