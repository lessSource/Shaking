//
//  CommentsHeaderView.swift
//  ImitationShaking
//
//  Created by Lj on 2019/6/2.
//  Copyright © 2019 study. All rights reserved.
//

import UIKit
import Kingfisher

class CommentsHeaderView: UIView {

    public var commentClick: ((Bool) -> ())?
    
    // 头像
    fileprivate lazy var headImage: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 18
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    // 姓名
    fileprivate lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.textColor_979797
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    // 时间
    fileprivate lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.textColor_979797
        label.font = UIFont.systemFont(ofSize: 11)
        return label
    }()
    
    // 内容
    fileprivate lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    // 点赞
    public lazy var praiseButton: UIButton = {
        let button = UIButton()
        button.setTitle("2", for: .normal)
        button.setImage(R.image.icon_giveLike(), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        return button
    }()
    
    public var model = CommentListModel() {
        didSet {
            nameLabel.text = model.submitUser.nickName
            timeLabel.text = model.createTime
            contentLabel.text = model.content
            if let url = URL(string: model.submitUser.headImg) {
                headImage.kf.setImage(with: ImageResource(downloadURL: url), placeholder: nil)
            }

        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK:- layoutView
    fileprivate func layoutView() {
        addSubview(headImage)
        addSubview(nameLabel)
        addSubview(timeLabel)
        addSubview(contentLabel)
        addSubview(praiseButton)
        
        contentLabel.isUserInteractionEnabled = true
        let contentTap = UITapGestureRecognizer(target: self, action: #selector(contentTapClick))
        contentLabel.addGestureRecognizer(contentTap)
        
        headImage.snp.makeConstraints { (make) in
            make.height.width.equalTo(36)
            make.left.equalTo(15)
            make.top.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalTo(headImage.snp.right).offset(4)
        }

        timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(headImage.snp.right).offset(4)
            make.top.equalTo(nameLabel.snp_bottom).offset(2)
        }

        contentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(headImage.snp.right).offset(4)
            make.top.equalTo(timeLabel.snp_bottom).offset(2)
            make.right.equalTo(self.snp_right).offset(-60)
        }

//        praiseButton.layoutButton(.top, imageTitleSpace: 2)
//        praiseButton.snp.makeConstraints { (make) in
//            make.width.height.equalTo(50)
//            make.top.equalToSuperview()
//            make.right.equalTo(self.snp_right).offset(-5)
//        }
        
        let userButton: UIButton = UIButton()
        userButton.addTarget(self, action: #selector(userButtonClick), for: .touchUpInside)
        addSubview(userButton)
        userButton.snp.makeConstraints { (make) in
            make.left.top.bottom.equalTo(headImage)
            make.right.equalTo(nameLabel.snp_right)
        }
        
    }
    
    // MARK:- Event
    // 内容
    @objc fileprivate func contentTapClick() {
        backgroundColor = UIColor(white: 0, alpha: 0.1)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.backgroundColor = .clear
        }
        if let closure = commentClick { closure(false) }
    }
    
    // 用户
    @objc fileprivate func userButtonClick() {
        if let closure = commentClick { closure(true) }
    }
    
}
