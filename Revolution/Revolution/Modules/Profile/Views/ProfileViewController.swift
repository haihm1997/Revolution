//
//  ProfileViewController.swift
//  Revolution
//
//  Created by Hoang Hai on 21/07/2021.
//  Copyright © 2021 TonyHoang. All rights reserved.
//

import UIKit
import RxCocoa

class ProfileViewController: BaseViewController {
    
    let viewModel = ProfileViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .orange
    }
    
}
