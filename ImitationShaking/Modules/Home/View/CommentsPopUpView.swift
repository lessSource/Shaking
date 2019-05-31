//
//  CommentsPopUpView.swift
//  ImitationShaking
//
//  Created by Lj on 2019/5/30.
//  Copyright © 2019 study. All rights reserved.
//

import UIKit

class CommentsPopUpView: PopUpContentView {
    
    fileprivate lazy var numberLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text = "333条评论"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 4
        clipsToBounds = true
//        backgroundColor = UIColor(white: 0.0, alpha: 0.9)
        backgroundColor = UIColor.red
        layoutView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK:- layoutView
    fileprivate func layoutView() {
        addSubview(numberLabel)
        numberLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(15)
        }
        
        let cancleButton = UIButton()
        cancleButton.setImage(R.image.icon_fork(), for: .normal)
        cancleButton.addTarget(self, action: #selector(cancleButtonClick), for: .touchUpInside)
        cancleButton.hitTestEdgeInsets = UIEdgeInsets(top: -10, left: -10, bottom: -10, right: -10)
        addSubview(cancleButton)
        cancleButton.snp.makeConstraints { (make) in
            make.height.width.equalTo(20)
            make.top.equalTo(15)
            make.right.equalToSuperview().offset(-15)
        }
        
    }
    
    // MARK:- Event
    @objc fileprivate func cancleButtonClick() {
        PopUpViewManager.sharedInstance.cancalContentView(self)
    }
    
}
