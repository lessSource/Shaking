//
//  AppDelegate.swift
//  ImitationShaking
//
//  Created by Lj on 2019/5/25.
//  Copyright © 2019 study. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window?.makeKeyAndVisible()
        window?.backgroundColor = .white
        
        let rootVC = BaseTabBarController()
        window?.rootViewController = rootVC
        do {
            try R.validate()
        } catch {
            
        }
        
        print(App.appName)

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


    func loginView() {
//        let loginVC = LoginPopUpView(frame: CGRect(x: 0, y: 0, width: Constant.screenWidth, height: Constant.screenHeight))
//        let loginVC = LoginViewController()
//        let nav = UINavigationController(rootViewController: loginVC)
//        window?.rootViewController = nav

//        let nav = BaseNavigationController(rootViewController: loginVC)
        
//        currentNav()?.present(nav, animated: true, completion: nil)
        
//        PopUpViewManager.sharedInstance.presentContentView(loginVC)
    }
    
//    func currentNav() -> UINavigationController? {
//
//
////        let tabbar = window?.rootViewController as? UITabBarController
////        return tabbar?.selectedViewController as? UINavigationController
//    }
    
    
//    + (UINavigationController *)currentNav {
//    UITabBarController *tabbarvc = (UITabBarController *)[UIApplication sharedApplication].delegate.window.rootViewController;
//    return tabbarvc.selectedViewController;
//    }
}

