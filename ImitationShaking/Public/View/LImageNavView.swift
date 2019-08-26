//
//  LImageNavView.swift
//  ImitationShaking
//
//  Created by Lj on 2019/8/22.
//  Copyright © 2019 study. All rights reserved.
//

import UIKit

class LImageNavView: UIView {
    
    public var maxNumber: Int = 1
    
    public var allNumber: Int = 0
//    {
//        didSet {
//            if self.allNumber == 0 {
//                completeButton.setTitleColor(UIColor(white: 0.0, alpha: 0.3), for: .normal)
//                completeButton.isUserInteractionEnabled = false
//                completeButton.setTitle("完成", for: .normal)
//            }else {
//                completeButton.setTitleColor(UIColor(white: 0.0, alpha: 1.0), for: .normal)
//                completeButton.isUserInteractionEnabled = true
//                completeButton.setTitle("完成(\(self.allNumber)/\(maxNumber))", for: .normal)
//            }
//            completeButton.width = CGFloat.minimum(completeButton.titleLabel?.intrinsicContentSize.width ?? 60, 120)
//            completeButton.x = Constant.screenWidth - completeButton.width - 15
//        }
//    }
    
    public lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 100, y: Constant.statusHeight, width: Constant.screenWidth - 200, height: Constant.topBarHeight)
        label.text = "所有图片"
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .center
        return label
    }()
    
    public lazy var backButton: UIButton = {
        let button = UIButton()
        button.setTitle("返回", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.setTitleColor(UIColor.black, for: .normal)
        button.contentHorizontalAlignment = .left
        button.frame = CGRect(x: 15, y: Constant.statusHeight + 2, width: 60, height: 40)
        button.addTarget(self, action: #selector(backButtonClick), for: .touchUpInside)
        return button
    }()
    
    public lazy var cancleButton: UIButton = {
        let button = UIButton()
        button.setTitle("取消", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.setTitleColor(UIColor.black, for: .normal)
        button.contentHorizontalAlignment = .right
        button.frame = CGRect(x: Constant.screenWidth - 75, y: Constant.statusHeight + 2, width: 60, height: 40)
        button.addTarget(self, action: #selector(completeButtonClick), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        addSubview(backButton)
        addSubview(cancleButton)
        maxNumber = 2
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- Event
    @objc fileprivate func backButtonClick() {
    }
    
    @objc fileprivate func completeButtonClick() {
        getControllerFromView()?.dismiss(animated: true, completion: nil)
    }
    
}
