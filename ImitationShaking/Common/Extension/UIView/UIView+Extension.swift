//
//  UIView+Extension UIView+Extension.swift
//  ConvenienceStore
//
//  Created by less on 2019/3/19.
//  Copyright © 2019 waterelephant. All rights reserved.
//

import UIKit

extension UIView {
    func corner(byRoundingCorners corners: UIRectCorner = .allCorners, radii: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radii, height: radii))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = maskPath.cgPath
        layer.mask = maskLayer
    }
    
    func shadow(byRoundingCorners corners: UIRectCorner = .allCorners) {
        layer.cornerRadius = 4
        layer.shadowColor = UIColor.withHex(hexString: "#000000", alpha: 0.1).cgColor
        layer.shadowOffset = CGSize.zero
        layer.shadowOpacity = 10
        layer.shadowRadius = 4
    }
    
    // 边界
    func canculateBallCenter(_ bottomHeigh: CGFloat = 75) {
        let viewHeight = (Constant.screenHeight - Constant.navbarAndStatusBar - Constant.barMargin)
        var buttonX = self.x
        var buttonY = self.y
        buttonX = buttonX > (Constant.screenWidth/2 - 30) ? (Constant.screenWidth - 75) : 15
        if buttonY < 15 {
            buttonY = 15
        }else if buttonY > (viewHeight - bottomHeigh) {
            buttonY = viewHeight - bottomHeigh
        }
        UIView.animate(withDuration: 0.3) {
            self.origin = CGPoint(x: buttonX, y: buttonY)
        }
    }
    
    func getControllerFromView() -> UIViewController? {
        for view in sequence(first: self.superview, next: {$0?.superview}) {
            if let responder = view?.next, responder is UIViewController {
                return responder as? UIViewController
            }
        }
        return nil
    }
    
    func showOscillatoryAnimation() {
        UIView.animate(withDuration: 0.15, delay: 0, options: [.beginFromCurrentState, .curveEaseInOut], animations: {
            self.layer.setValue(0.92, forKeyPath: "transform.scale")
        }) { (finished) in
            UIView.animate(withDuration: 0.15, delay: 0, options: [.beginFromCurrentState, .curveEaseInOut], animations: {
                self.layer.setValue(0.92, forKeyPath: "transform.scale")
            }) { (finished) in
                UIView.animate(withDuration: 0.1, delay: 0, options: [.beginFromCurrentState, .curveEaseInOut], animations: {
                    self.layer.setValue(1.0, forKeyPath: "transform.scale")
                }, completion: nil)
            }
        }
    }
    
}
