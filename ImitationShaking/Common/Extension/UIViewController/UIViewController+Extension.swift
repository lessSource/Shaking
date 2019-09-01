//
//  UIViewController+Extension.swift
//  ImitationShaking
//
//  Created by Lj on 2019/6/28.
//  Copyright © 2019 study. All rights reserved.
//

import UIKit

extension UIViewController {
    
    fileprivate func pushViewController(_ viewController: UIViewController, animated: Bool, hideTabbar: Bool) {
        viewController.hidesBottomBarWhenPushed = hideTabbar
        navigationController?.pushViewController(viewController, animated: animated)
    }
    
    /** push */
    public func pushAndHideTabbar(_ viewController: UIViewController) {
        pushViewController(viewController, animated: true, hideTabbar: true)
    }
    
    public func pushHidePopShowTabbar(_ viewController: UIViewController) {
        hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    /** present */
    public func presentViewController(_ viewController: UIViewController, completion: (() -> ())?) {
        let nav: BaseNavigationController = BaseNavigationController(rootViewController: viewController)
        present(nav, animated: true, completion: completion)
    }
    
    public func showAlertWithTitle(_ title: String) {
        let alertVC = UIAlertController(title: "提示", message: title, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertVC.addAction(okAction)
        present(alertVC, animated: true, completion: nil)
    }
}
