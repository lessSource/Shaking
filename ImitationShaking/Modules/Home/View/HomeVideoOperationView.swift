//
//  HomeVideoOperationView.swift
//  ImitationShaking
//
//  Created by Lj on 2019/5/26.
//  Copyright © 2019 study. All rights reserved.
//

import UIKit

class HomeVideoOperationView: UIView {
    
    // 评论页面
    fileprivate lazy var commentsView: CommentsPopUpView = {
        let comments = CommentsPopUpView(frame: CGRect(x: 0, y: Constant.screenHeight/4, width: Constant.screenWidth, height: Constant.screenHeight/4*3))
        return comments
    }()
    
    // 分享
    fileprivate lazy var shareView: SharePopUpView = {
        let share = SharePopUpView(frame: CGRect(x: 0, y: Constant.screenHeight/2, width: Constant.screenWidth, height: Constant.screenHeight/2))
        return share
    }()
    
    /** 音乐名称 */
    fileprivate lazy var musicLabel: UILabel = {
        let label = UILabel()
        label.text = "这是谁的原创音乐"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    /** 音乐图片 */
    fileprivate lazy var musicImage: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 25
        image.layer.borderColor = UIColor.gray.cgColor
        image.layer.borderWidth = 10
        image.backgroundColor = .red
        image.clipsToBounds = true
        return image
    }()
    
    /** 发布文字内容 */
    fileprivate lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.text = "终于学会分身术一起合照了。可是我还没唱完就跑了，哈哈哈哈哈哈哈哈"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()
    
    /** 发布用户名称 */
    fileprivate lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "@芥末"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    /** 用户头像 */
    fileprivate lazy var headerImage: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 24
        image.layer.borderColor = UIColor.white.cgColor
        image.layer.borderWidth = 1
        image.backgroundColor = .red
        image.clipsToBounds = true
        return image
    }()
    
    /** 分享 */
    fileprivate lazy var shareButton: UIButton = {
        let button = UIButton()
        button.setTitle("34.2W", for: .normal)
        button.setImage(R.image.icon_share(), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        return button
    }()
    
    /** 评论 */
    fileprivate lazy var commentsButton: UIButton = {
        let button = UIButton()
        button.setTitle("34.2W", for: .normal)
        button.setImage(R.image.icon_comments(), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        return button
    }()
    
    /** 点赞 */
    fileprivate lazy var givelikeButton: UIButton = {
        let button = UIButton()
        button.setTitle("34.2W", for: .normal)
        button.setImage(R.image.icon_giveLike(), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        return button
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(white: 1.0, alpha: 0.0)
        layoutView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- layout
    fileprivate func layoutView() {
        let notesImage = UIImageView()
        notesImage.image = R.image.icon_notes()
        self.addSubview(notesImage)
        notesImage.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.width.height.equalTo(15)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        addSubview(musicLabel)
        musicLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(notesImage)
            make.left.equalTo(notesImage.snp_right).offset(2)
            make.width.equalTo(Constant.screenWidth/2)
        }
        
        addSubview(shareButton)
        shareButton.addTarget(self, action: #selector(shareButtonClick), for: .touchUpInside)
        shareButton.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-80)
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(50)
            make.width.equalTo(shareButton.titleLabel?.intrinsicContentSize.width ?? 0)
        }
        shareButton.layoutButton(.top, imageTitleSpace: 2)
        
        addSubview(commentsButton)
        commentsButton.addTarget(self, action: #selector(commentsButtonClick), for: .touchUpInside)
        commentsButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(shareButton)
            make.height.equalTo(50)
            make.bottom.equalTo(shareButton.snp_top).offset(-20)
            make.width.equalTo(commentsButton.titleLabel?.intrinsicContentSize.width ?? 0)
        }
        commentsButton.layoutButton(.top, imageTitleSpace: 2)
        
        addSubview(givelikeButton)
        givelikeButton.addTarget(self, action: #selector(givelikeButtonClick), for: .touchUpInside)
        givelikeButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(shareButton)
            make.height.equalTo(50)
            make.bottom.equalTo(commentsButton.snp_top).offset(-20)
            make.width.equalTo(givelikeButton.titleLabel?.intrinsicContentSize.width ?? 0)
        }
        givelikeButton.layoutButton(.top, imageTitleSpace: 2)
        
        addSubview(headerImage)
        headerImage.snp.makeConstraints { (make) in
            make.width.height.equalTo(48)
            make.centerX.equalTo(givelikeButton)
            make.bottom.equalTo(givelikeButton.snp_top).offset(-40)
        }
        
        addSubview(contentLabel)
        contentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalTo(shareButton.snp_left).offset(-10)
            make.bottom.equalTo(musicLabel.snp_top).offset(-10)
        }
        
        addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalToSuperview().offset(-100)
            make.bottom.equalTo(contentLabel.snp_top).offset(-10)
        }
        
        addSubview(musicImage)
        musicImage.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-10)
            make.width.height.equalTo(50)
            make.centerX.equalTo(givelikeButton)
        }
        
    }
}

// MARK:- Event
extension HomeVideoOperationView {
    
    // 点赞
    @objc fileprivate func givelikeButtonClick() {
        
    }
    
    // 评论
    @objc fileprivate func commentsButtonClick() {
        PopUpViewManager.sharedInstance.presentContentView(commentsView)
    }
    
    // 分享
    @objc fileprivate func shareButtonClick() {
        PopUpViewManager.sharedInstance.presentContentView(shareView)
    }
}
