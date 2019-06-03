//
//  MBAlertUtil.swift
//  ImitationShaking
//
//  Created by less on 2019/6/3.
//  Copyright © 2019 study. All rights reserved.
//

import UIKit
import MBProgressHUD

class MBAlertUtil {
    
    static let alertManager = MBAlertUtil()
    
    /** 默认简短提示语显示时间 */
    let kShowTime: TimeInterval = 1.0
    
    /** 默认超时时间，30s后自动去除提示框 */
    let interval: TimeInterval = 30.0
    
    var promptHUDTag: Int = 0
    
    fileprivate lazy var loadingHUD = MBProgressHUD()
    
    fileprivate lazy var promptHUD = MBProgressHUD()
    
    private init() { }
    
}


extension MBAlertUtil {
    
    public func showPromptInfo(_ info: String, in view: UIView = App.keyWindow) {
        DispatchQueue.main.async {
            self.promptHUD = MBProgressHUD.showAdded(to: view, animated: true)
            self.promptHUD.label.text = info
            self.promptHUD.label.numberOfLines = 0
            self.promptHUD.animationType = .zoom
            self.promptHUD.mode = .text
            self.promptHUD.removeFromSuperViewOnHide = true
            self.promptHUD.hide(animated: true, afterDelay: self.kShowTime)
        }
    }
    
    public func showLoadingMessage(_ info: String = "", in view: UIView = App.keyWindow) {
        hiddenLoading()
        loadingHUD = MBProgressHUD(view: view)
        promptHUDTag = Int(arc4random())
        loadingHUD.tag = promptHUDTag
        loadingHUD.removeFromSuperViewOnHide = true
        loadingHUD.label.text = info
        view.addSubview(loadingHUD)
        view.bringSubviewToFront(loadingHUD)
        loadingHUD.show(animated: true)
        hideAlertDelay()
    }
    
    public func hiddenLoading() {
        if self.promptHUDTag == self.loadingHUD.tag {
            loadingHUD.hide(animated: true)
            promptHUDTag = 0
        }
    }
    
    fileprivate func hideAlertDelay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
            self.hiddenLoading()
        }
    }
}
