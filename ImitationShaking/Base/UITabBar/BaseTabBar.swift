//
//  BaseTabBar.swift
//  ImitationShaking
//
//  Created by Lj on 2019/5/25.
//  Copyright © 2019 study. All rights reserved.
//

import UIKit

class BaseTabBar: UITabBar {
    
    fileprivate lazy var publishBtn: UIButton = {
        let button = UIButton()
        button.setImage(R.image.icon_btn_add(), for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundImage = UIImage.colorCreateImage(UIColor.clear, size: CGSize(width: Constant.screenWidth, height: Constant.bottomBarHeight))
        addSubview(publishBtn)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var btnX: CGFloat = 0
        let btnY: CGFloat = 0
        let btnW: CGFloat = width / 5
        var btnH: CGFloat = 0
        
        publishBtn.frame = CGRect(x: 0, y: 0, width: btnW, height: 49)
        publishBtn.center = CGPoint(x: width / 2, y: 49 / 2)
        
        var index = 0
        
        for item in subviews {
            if !(item is UIControl) || item == publishBtn {
                continue
            }
            
            btnX = btnW * CGFloat((index > 1 ? index + 1 : index ))
            btnH = item.height
            item.frame = CGRect(x: btnX, y: btnY, width: btnW, height: btnH)
            index += 1
        }

    }
    
}



