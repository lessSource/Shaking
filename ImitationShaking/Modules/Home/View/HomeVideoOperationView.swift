//
//  HomeVideoOperationView.swift
//  ImitationShaking
//
//  Created by Lj on 2019/5/26.
//  Copyright © 2019 study. All rights reserved.
//

import UIKit
import Kingfisher

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
        image.image = R.image.icon_music()
        image.clipsToBounds = true
        return image
    }()
    
    /** 发布文字内容 */
    fileprivate lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()
    
    /** 发布用户名称 */
    fileprivate lazy var nameLabel: UILabel = {
        let label = UILabel()
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
        image.clipsToBounds = true
        return image
    }()
    
    /** 分享 */
    fileprivate lazy var shareButtonView: VideoButtonView = {
        let buttonView = VideoButtonView()
        buttonView.imageView.image = R.image.icon_share()
        buttonView.numberLabel.text = "0"
        return buttonView
    }()
    
    /** 评论 */
    fileprivate lazy var commentsButtonView: VideoButtonView = {
        let buttonView = VideoButtonView()
        buttonView.imageView.image = R.image.icon_comments()
        buttonView.numberLabel.text = "0"
        return buttonView
    }()
    
    /** 点赞 */
    fileprivate lazy var givelikeButtonView: VideoButtonView = {
        let buttonView = VideoButtonView()
        buttonView.imageView.image = R.image.icon_giveLike()
        buttonView.numberLabel.text = "0"
        return buttonView
    }()
    
    public var listModel = HomeVideoListModel() {
        didSet {
            musicLabel.text = "暂无字段"
            contentLabel.text = listModel.title
            nameLabel.text = "@\(listModel.submitUser.nickName)"
            shareButtonView.numberLabel.text = listModel.shareCount.formatting
            commentsButtonView.numberLabel.text = listModel.commentCount.formatting
            givelikeButtonView.numberLabel.text = listModel.praiseCount.formatting
            givelikeButtonView.imageView.image = listModel.isPraise == 0 ? R.image.icon_giveLike() : R.image.icon_giveLike_click()
            if let url = URL(string: listModel.submitUser.headImg) {
                headerImage.kf.setImage(with: ImageResource(downloadURL: url), placeholder: nil)
            }
        }
    }
    
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
            make.left.equalTo(notesImage.snp.right).offset(2)
            make.width.equalTo(Constant.screenWidth/2)
        }
        
        addSubview(musicImage)
        musicImage.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-10)
            make.width.height.equalTo(50)
            make.right.equalToSuperview().offset(-15)
        }
        
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.fromValue = NSNumber(value: 0)
        animation.toValue = NSNumber(value: Double.pi * 2)
        animation.duration = 3
        animation.repeatCount = HUGE // 无限重复
        musicImage.layer.add(animation, forKey: "centerLayer")
        
        addSubview(shareButtonView)
        shareButtonView.button.addTarget(self, action: #selector(shareButtonClick), for: .touchUpInside)
        shareButtonView.snp.makeConstraints { (make) in
            make.bottom.equalTo(musicImage.snp.top).offset(-25)
            make.height.width.equalTo(50)
            make.centerX.equalTo(musicImage)
        }
        
        addSubview(commentsButtonView)
        commentsButtonView.button.addTarget(self, action: #selector(commentsButtonClick), for: .touchUpInside)
        commentsButtonView.snp.makeConstraints { (make) in
            make.bottom.equalTo(shareButtonView.snp.top).offset(-25)
            make.height.width.equalTo(50)
            make.centerX.equalTo(musicImage)
        }
        
        addSubview(givelikeButtonView)
        givelikeButtonView.button.addTarget(self, action: #selector(givelikeButtonClick), for: .touchUpInside)
        givelikeButtonView.snp.makeConstraints { (make) in
            make.bottom.equalTo(commentsButtonView.snp.top).offset(-25)
            make.height.width.equalTo(50)
            make.centerX.equalTo(musicImage)
        }
        
        addSubview(headerImage)
        headerImage.snp.makeConstraints { (make) in
            make.width.height.equalTo(48)
            make.centerX.equalTo(givelikeButtonView)
            make.bottom.equalTo(givelikeButtonView.snp.top).offset(-30)
        }
        
        addSubview(contentLabel)
        contentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalTo(shareButtonView.snp.left).offset(-5)
            make.bottom.equalTo(musicLabel.snp.top).offset(-10)
        }
        
        addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalToSuperview().offset(-100)
            make.bottom.equalTo(contentLabel.snp.top).offset(-10)
        }

    }
}

// MARK:- Event
extension HomeVideoOperationView {
    
    // 点赞
    @objc fileprivate func givelikeButtonClick() {
        praiseAnimate()
    }
    
    // 评论
    @objc fileprivate func commentsButtonClick() {
        commentsView.numberLabel.text = "\(listModel.commentCount)条评论"
        commentsView.sourceId = listModel.id
//        viewController()?.tabBarController?.tabBar.isHidden = true
        PopUpViewManager.sharedInstance.presentContentView(commentsView)
    }
    
    // 分享
    @objc fileprivate func shareButtonClick() {
        PopUpViewManager.sharedInstance.presentContentView(shareView)
    }
    
    // 点赞动画
    fileprivate func praiseAnimate() {
        UIView.animate(withDuration: 0.2, animations: {
            self.givelikeButtonView.imageView.size = CGSize(width: 25, height: 25)
        }, completion: { (success) in
            self.givelikeButtonView.imageView.size = CGSize(width: 32, height: 32)
        })
    }
}


class VideoButtonView: UIView {
    
    public lazy var imageView: UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    public lazy var numberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.white
        return label
    }()
    
    public lazy var button: UIButton = {
        let button = UIButton()
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- layoutView
    fileprivate func layoutView() {
        addSubview(numberLabel)
        addSubview(imageView)
        addSubview(button)
        
        numberLabel.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { (make) in
            make.width.height.equalTo(32)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        button.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}
