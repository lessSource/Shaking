//
//  BaseTabBarController.swift
//  ImitationShaking
//
//  Created by Lj on 2019/5/25.
//  Copyright © 2019 study. All rights reserved.
//

import UIKit

class BaseTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // 首页
        addChildViewController(HomeViewController(), title: "首页")
        
        // 好友
        addChildViewController(FriendsViewController(), title: "好友")

        // 添加
        addChildViewController(VideoUpdateViewController(), title: "首页")
        
        // 消息
        addChildViewController(MessageViewController(), title: "消息")
        
        // 我的
        addChildViewController(MineViewController(), title: "我的")
        
        tabBar.isTranslucent = true
        tabBar.backgroundImage = UIImage()
        tabBar.shadowImage = UIImage.colorCreateImage(.lineColor_191D20, size: CGSize(width: Constant.screenWidth, height: 1))
        tabBar.backgroundColor = .clear
        tabBar.tintColor = .white
    }
    
    private func addChildViewController(_ childController: UIViewController, title: String = "", imageName: String = "", selectedImage: String = "") {
        //1.设置子控制器的tabBarItem的标题图片
        childController.title = title
        childController.tabBarItem.imageInsets = UIEdgeInsets(top: 49, left: 0, bottom: 49, right: 0)
//        childController.tabBarItem.image = UIImage(named: imageName)
//        childController.tabBarItem.selectedImage = UIImage(named: selectedImage)
        
        //添加子控制器
        let chidNav = BaseNavigationController(rootViewController: childController)
        addChild(chidNav)
    }
    

}
