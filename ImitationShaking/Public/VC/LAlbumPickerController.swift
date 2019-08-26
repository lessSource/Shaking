//
//  LAlbumPickerController.swift
//  ImitationShaking
//
//  Created by Lj on 2019/8/26.
//  Copyright © 2019 study. All rights reserved.
//

import UIKit

class LAlbumPickerController: UIViewController {

    
    fileprivate lazy var navView: LImageNavView = {
        let navView = LImageNavView(frame: CGRect(x: 0, y: 0, width: Constant.screenWidth, height: Constant.navbarAndStatusBar))
        navView.backButton.isHidden = true
        navView.titleLabel.text = "全部图片 "
        navView.backgroundColor = UIColor.white
        return navView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        view.addSubview(navView)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let photoVC = LPhotoPickerController()
        navigationController?.pushViewController(photoVC, animated: true)
    }

}
