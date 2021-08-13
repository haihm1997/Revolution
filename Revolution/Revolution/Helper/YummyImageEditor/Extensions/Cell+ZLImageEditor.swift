//
//  HomeViewController.swift
//  Revolution
//
//  Created by Hoang Hai on 19/07/2021.
//  Copyright © 2021 TonyHoang. All rights reserved.
//

import UIKit

extension UICollectionViewCell {
    
    class func zl_identifier() -> String {
        return NSStringFromClass(self.classForCoder())
    }
    
    class func zl_register(_ collectionView: UICollectionView) {
        collectionView.register(self.classForCoder(), forCellWithReuseIdentifier: self.zl_identifier())
    }
    
}

extension UITableViewCell {
    
    class func zl_identifier() -> String {
        return NSStringFromClass(self.classForCoder())
    }
    
    class func zl_register(_ tableView: UITableView) {
        tableView.register(self.classForCoder(), forCellReuseIdentifier: self.zl_identifier())
    }
    
}
