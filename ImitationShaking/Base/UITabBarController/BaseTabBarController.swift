//
//  BaseTabBarController.swift
//  ImitationShaking
//
//  Created by Lj on 2019/5/25.
//  Copyright © 2019 study. All rights reserved.
//

import UIKit

class BaseTabBarController: UITabBarController {

    fileprivate lazy var baseTabBar: BaseTabBar = {
        let bar = BaseTabBar()
//        bar.delegate = self
        return bar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = self
        
        setValue(baseTabBar, forKey: "tabBar")
        
        // 首页
        addChildViewController(HomeViewController(), title: "首页")
        
        // 好友
        addChildViewController(FriendsViewController(), title: "好友")

        // 添加
//        addChildViewController(VideoUpdateViewController(), title: "首页")
        
        // 消息
        addChildViewController(MessageViewController(), title: "消息")
        
        // 我的
        addChildViewController(MineViewController(), title: "我的")
    }
    
    private func addChildViewController(_ childController: UIViewController, title: String = "", imageName: String = "", selectedImage: String = "") {
        //1.设置子控制器的tabBarItem的标题图片
        childController.tabBarItem.title = title
        
        childController.tabBarItem.image = UIImage.colorCreateImage(UIColor.clear, size: CGSize(width: 36, height: 3)).withRenderingMode(.alwaysOriginal)
        childController.tabBarItem.selectedImage = UIImage.colorCreateImage(UIColor.white, size: CGSize(width: 36, height: 3)).withRenderingMode(.alwaysOriginal)

        childController.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -14)
        childController.tabBarItem.imageInsets = UIEdgeInsets(top: 28, left: 0, bottom: -28, right: 0)
        childController.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor(white: 1.0, alpha: 0.6)], for: .normal)
        childController.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        //添加子控制器
        let chidNav = BaseNavigationController(rootViewController: childController)
        addChild(chidNav)
    }
    
//    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
//        print(item)
//
//    }

    
    
}

extension BaseTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if LCacheModel.shareInstance.getData().token.isEmpty {
            let loginVC = LoginViewController()
            loginVC.view.backgroundColor = UIColor(white: 0, alpha: 0.9)
            self.definesPresentationContext = true
            loginVC.modalPresentationStyle = .overCurrentContext
            present(loginVC, animated: true, completion: nil)
            return false
        }
        return true
    }
}

