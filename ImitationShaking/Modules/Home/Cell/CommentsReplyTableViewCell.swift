//
//  CommentsReplyTableViewCell.swift
//  ImitationShaking
//
//  Created by Lj on 2019/5/31.
//  Copyright © 2019 study. All rights reserved.
//

import UIKit
import Kingfisher

class CommentsReplyTableViewCell: UITableViewCell {

    // 头像
    fileprivate lazy var headImage: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 13
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
    fileprivate lazy var praiseButton: UIButton = {
        let button = UIButton()
        button.setTitle("2222", for: .normal)
        button.setImage(R.image.icon_giveLike(), for: .normal)
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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = UIColor.clear
        layoutView()
    }
    
    // MARK:- layoutView
    fileprivate func layoutView() {
        addSubview(headImage)
        addSubview(nameLabel)
        addSubview(timeLabel)
        addSubview(contentLabel)
        addSubview(praiseButton)
        
        headImage.snp.makeConstraints { (make) in
            make.height.width.equalTo(26)
            make.left.equalTo(55)
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
            make.right.equalToSuperview().offset(-60)
            make.bottom.equalToSuperview().offset(-5)
        }
        
        praiseButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.right.equalToSuperview().offset(-15)
//            make
        }
        
    }
}
