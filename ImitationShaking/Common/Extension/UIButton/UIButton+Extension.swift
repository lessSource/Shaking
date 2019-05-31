//
//  UIButton+Extension.swift
//  ImitationShaking
//
//  Created by Lj on 2019/5/29.
//  Copyright © 2019 study. All rights reserved.
//

import UIKit

enum ButtonEdgeInsetsStyle {
    case top
    case left
    case right
    case bottom
}


extension UIButton {
    
    private struct AssociatedKeys {
        static var buttonView: String = "buttonViewKey"
    }
    
    // 边距扩充
    var hitTestEdgeInsets: UIEdgeInsets? {
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.buttonView, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.buttonView) as? UIEdgeInsets ?? UIEdgeInsets.zero
        }
    }
    
    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if hitTestEdgeInsets == UIEdgeInsets.zero || !isEnabled || isHidden {
            return super.point(inside: point, with: event)
        }
        return bounds.inset(by: hitTestEdgeInsets ?? UIEdgeInsets.zero).contains(point)
      }
    
    func layoutButton(_ style: ButtonEdgeInsetsStyle, imageTitleSpace: CGFloat) {
        let imageWidth = imageView?.width ?? 0
        let imageHeight = imageView?.height ?? 0
        
        let labelWidth = titleLabel?.intrinsicContentSize.width ?? 0
        let labelHeight = titleLabel?.intrinsicContentSize.height ?? 0
        
        var imageInsets = UIEdgeInsets.zero
        var labelInsets = UIEdgeInsets.zero

        switch style {
        case .top:
            imageInsets = UIEdgeInsets(top: -labelHeight - imageTitleSpace/2, left: 0, bottom: 0, right: -labelWidth)
            labelInsets = UIEdgeInsets(top: 0, left: -imageWidth, bottom: -imageHeight - imageTitleSpace/2, right: 0)
        case .left:
            imageInsets = UIEdgeInsets(top: 0, left: -imageTitleSpace/2, bottom: 0, right: imageTitleSpace)
            labelInsets = UIEdgeInsets(top: 0, left: imageTitleSpace/2, bottom: 0, right: -imageTitleSpace/2)
        case .bottom:
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: -labelHeight - imageTitleSpace/2, right: -labelWidth)
            labelInsets = UIEdgeInsets(top: -imageHeight - imageTitleSpace/2, left: -imageWidth, bottom: 0, right: 0)
        case .right:
            imageInsets = UIEdgeInsets(top: 0, left: labelWidth + imageTitleSpace/2, bottom: 0, right: -labelWidth - imageTitleSpace/2)
            labelInsets = UIEdgeInsets(top: 0, left: -imageWidth - imageTitleSpace/2, bottom: 0, right: imageWidth + imageTitleSpace/2)
            
        }
        titleEdgeInsets = labelInsets
        imageEdgeInsets = imageInsets
    }
    
    
    
}
