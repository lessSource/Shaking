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
        return bar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        
//        tabBar.isTranslucent = true
//        tabBar.backgroundImage = UIImage()
//        tabBar.shadowImage = UIImage.colorCreateImage(.lineColor_191D20, size: CGSize(width: Constant.screenWidth, height: 1))
//        tabBar.backgroundColor = .clear
//        tabBar.tintColor = .white
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
    

}
