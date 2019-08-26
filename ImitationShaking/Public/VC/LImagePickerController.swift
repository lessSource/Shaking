//
//  LImagePickerController.swift
//  ImitationShaking
//
//  Created by Lj on 2019/8/21.
//  Copyright © 2019 study. All rights reserved.
//

import UIKit

class LImagePickerController: UINavigationController {

    deinit {
        print(self, "+++++释放")
    }
    
    convenience init() {
        let albumPickerVC = LAlbumPickerController()
        self.init(rootViewController: albumPickerVC)
    }
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        delegate = self
        if self.responds(to: #selector(getter: interactivePopGestureRecognizer)) {
            self.interactivePopGestureRecognizer?.delegate = self
        }
        
        let photoPicker = LPhotoPickerController()
        pushViewController(photoPicker, animated: true)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var childForStatusBarStyle: UIViewController? {
        return self.visibleViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarHidden(true, animated: true)
    }
    
}


extension LImagePickerController: UIGestureRecognizerDelegate, UINavigationControllerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if navigationController?.viewControllers.count == 1 {
            return false
        }else {
            return true
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if navigationController.responds(to: #selector(getter: interactivePopGestureRecognizer)) {
            navigationController.interactivePopGestureRecognizer?.isEnabled = true
        }
        if navigationController.viewControllers.count == 1 {
            navigationController.interactivePopGestureRecognizer?.isEnabled = false
            navigationController.interactivePopGestureRecognizer?.delegate = nil
        }
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.responds(to: #selector(getter: interactivePopGestureRecognizer)) {
            self.interactivePopGestureRecognizer?.isEnabled = false
        }
        super.pushViewController(viewController, animated: true)
    }
    
}

