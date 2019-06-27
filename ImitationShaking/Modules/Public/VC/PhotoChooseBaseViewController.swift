//
//  PhotoChooseBaseViewController.swift
//  ImitationShaking
//
//  Created by less on 2019/6/25.
//  Copyright © 2019 study. All rights reserved.
//

import UIKit
import VTMagic

class PhotoChooseBaseViewController: BaseViewController {

    fileprivate lazy var magicVC: VTMagicController = {
        let magic = VTMagicController()
        magic.magicView.frame = CGRect(x: 0, y: Constant.statusHeight + 80, width: Constant.screenWidth, height: Constant.screenHeight - 80 - Constant.statusHeight)
        magic.magicView.navigationColor = UIColor.white
        magic.magicView.layoutStyle = .divide
        magic.magicView.switchStyle = .default
        magic.magicView.navigationHeight = 40
        magic.magicView.isSliderHidden = true
        magic.magicView.dataSource = self
        magic.magicView.delegate = self
        return magic
    }()
    
    fileprivate lazy var contentView: UIView = {
        let contentView = UIView(frame: CGRect(x: 0, y: Constant.statusHeight, width: Constant.screenWidth, height: Constant.screenHeight - Constant.statusHeight))
        contentView.backgroundColor = UIColor.white
        contentView.corner(byRoundingCorners: [.topLeft, .topRight], radii: 10)
        return contentView
    }()
    
    fileprivate lazy var nextButton: UIButton = {
        let button: UIButton = UIButton(type: .custom)
        button.setTitle("下一歩", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitleColor(UIColor.red, for: .normal)
        return button
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addChild(magicVC)
        view.addSubview(contentView)
        view.addSubview(magicVC.view)
        magicVC.magicView.reloadData()
        
        let cancleButton = UIButton(frame: CGRect(x: 15, y: 15, width: 40, height: 40))
        cancleButton.backgroundColor = UIColor.red
        cancleButton.addTarget(self, action: #selector(cancleButtonClick), for: .touchUpInside)
        contentView.addSubview(cancleButton)
        
        let allPhoto: UIButton = UIButton()
        allPhoto.setTitleColor(UIColor.black, for: .normal)
        allPhoto.setTitle("所有照片", for: .normal)
        allPhoto.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        contentView.addSubview(allPhoto)
        allPhoto.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(15)
        }
        
        contentView.addSubview(nextButton)
        nextButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-15)
            make.centerY.equalTo(allPhoto)
        }
        
    }
    
    // MARK: - Event
    @objc fileprivate func cancleButtonClick() {
        dismiss(animated: true, completion: nil)
    }
    
}



extension PhotoChooseBaseViewController: VTMagicViewDelegate, VTMagicViewDataSource {
    func menuTitles(for magicView: VTMagicView) -> [String] {
        return ["视频", "图片"]
    }

    func magicView(_ magicView: VTMagicView, menuItemAt itemIndex: UInt) -> UIButton {
        var button: UIButton? = magicView.dequeueReusableItem(withIdentifier: UIButton.identifire)
        if button == nil {
            button = UIButton(type: .custom)
            button?.setTitleColor(UIColor.black, for: .selected)
            button?.setTitleColor(UIColor(white: 0.0, alpha: 0.5), for: .normal)
            button?.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        }
        return button!
    }

    func magicView(_ magicView: VTMagicView, viewControllerAtPage pageIndex: UInt) -> UIViewController {
        var magicVC = magicView.dequeueReusablePage(withIdentifier: PhotosChooseViewController.identifire) as? PhotosChooseViewController
        if magicVC == nil {
            magicVC = PhotosChooseViewController()
        }
        magicVC?.mediaType = pageIndex == 0 ? .video : .image
        return magicVC!
    }


}
