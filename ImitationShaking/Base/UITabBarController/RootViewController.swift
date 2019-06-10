//
//  RootViewController.swift
//  ImitationShaking
//
//  Created by less on 2019/6/10.
//  Copyright © 2019 study. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {

    public var isTabbar: Bool = false
    
    public lazy var tabBarVC: BaseTabBarController = {
        let tabbarVC = BaseTabBarController()
        return tabbarVC
    }()
    
    public lazy var mineVC: MineViewController = {
        let mineVC = MineViewController()
        return mineVC
    }()
    
    public lazy var publicShootVC: PublicShootViewController = {
        let publicShootVC = PublicShootViewController()
        return publicShootVC
    }()
    
    public lazy var navVC: BaseNavigationController = {
        let navVC = BaseNavigationController(rootViewController: self.mineVC)
        return navVC
    }()
    
    
    fileprivate lazy var scorllView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.backgroundColor = UIColor.clear
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
//        scrollView.isScrollEnabled = false
        scrollView.delegate = self
        scrollView.bounces = false
        return scrollView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        layoutView()
    }
    
    // MARK:- layoutView
    fileprivate func layoutView() {
        view.addSubview(scorllView)
        
        isTabbar = true
        scorllView.contentSize = CGSize(width: Constant.screenWidth * 3, height: Constant.screenHeight)
        scorllView.contentOffset = CGPoint(x: Constant.screenWidth, y: Constant.screenHeight)
        
        publicShootVC.view.frame = CGRect(x: 0, y: 0, width: Constant.screenWidth, height: Constant.screenHeight)
        scorllView.addSubview(publicShootVC.view)

        tabBarVC.view.frame = CGRect(x: Constant.screenWidth, y: 0, width: Constant.screenWidth, height: Constant.screenHeight)
        scorllView.addSubview(tabBarVC.view)
        
        mineVC.view.frame = CGRect(x: Constant.screenWidth * 2, y: 0, width: Constant.screenWidth, height: Constant.screenHeight)
        scorllView.addSubview(mineVC.view)
        
        addChild(publicShootVC)
        addChild(tabBarVC)
        addChild(mineVC)
        
    }

    
    override var shouldAutorotate: Bool {
        return tabBarVC.shouldAutorotate
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return tabBarVC.supportedInterfaceOrientations
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return tabBarVC.preferredInterfaceOrientationForPresentation
    }
    
    override var childForStatusBarStyle: UIViewController? {
        return tabBarVC
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scorllView.frame = view.bounds
        publicShootVC.view.frame = CGRect(x: 0, y: 0, width: scorllView.width, height: scorllView.height)
        tabBarVC.view.frame = CGRect(x: scorllView.width, y: 0, width: scorllView.width, height: scorllView.height)
        mineVC.view.frame = CGRect(x: scorllView.width * 2, y: 0, width: scorllView.width, height: scorllView.height)
        
    }
    
}


extension RootViewController: UIScrollViewDelegate {
    
}
