//
//  PublicReleaseViewController.swift
//  ImitationShaking
//
//  Created by Lj on 2019/6/28.
//  Copyright © 2019 study. All rights reserved.
//

import UIKit

class PublicReleaseViewController: BaseViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "发布"
        initView()
    }

    // MARK: - initView
    fileprivate func initView() {
        
    }
    
}
