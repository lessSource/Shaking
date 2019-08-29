//
//  LImagePickerController.swift
//  ImitationShaking
//
//  Created by Lj on 2019/8/21.
//  Copyright © 2019 study. All rights reserved.
//

import UIKit
import Photos

protocol LImagePickerDelegate: NSObjectProtocol {
    
}

class LImagePickerController: UINavigationController {

    private weak var imageDelagete: LImagePickerDelegate?
    
    private(set) var maxSelectCount: Int = 0
    
    public var selectArray = [LMediaResourcesModel]()

    deinit {
        print(self, "+++++释放")
    }
    
    convenience init(withMaxImage count: Int, delegate: LImagePickerDelegate?) {
        let albumPickerVC = LAlbumPickerController()
        self.init(rootViewController: albumPickerVC)
        self.imageDelagete = delegate
        self.maxSelectCount = count < 1 ? 1 : count
    }
    
    private override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        delegate = self
        if self.responds(to: #selector(getter: interactivePopGestureRecognizer)) {
            self.interactivePopGestureRecognizer?.delegate = self
        }
        if PHPhotoLibrary.authorizationStatus() == .authorized {
            let photoPicker = LPhotoPickerController()
            self.pushViewController(photoPicker, animated: true)
        }
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
    
    private func reuquetsPhotosAuthorization() {
        if !LImagePickerManager.shared.reuquetsPhotosAuthorization() {
            view.placeholderShow(true) { (promptView) in
                promptView.imageName(R.image.icon_permissions.name)
                promptView.title("请在iPhone的\'设置-隐私-照片'选项中\r允许\(App.appName)访问你的手机相册")
                promptView.titleLabel.height = 60
                promptView.imageTop(Constant.screenHeight/2 - 150)
//                promptView.delegate = self
            }
        }
    }
    
    public func showAlertWithTitle(_ title: String) {
        let alertVC = UIAlertController(title: "提示", message: title, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertVC.addAction(okAction)
        present(alertVC, animated: true, completion: nil)
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

