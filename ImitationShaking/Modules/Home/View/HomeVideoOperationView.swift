//
//  HomeVideoOperationView.swift
//  ImitationShaking
//
//  Created by Lj on 2019/5/26.
//  Copyright © 2019 study. All rights reserved.
//

import UIKit

class HomeVideoOperationView: UIView {
    
    fileprivate lazy var musicLabel: UILabel = {
        let label = UILabel()
        label.text = "这是谁的原创音乐"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    fileprivate lazy var musicImage: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 25
        image.layer.borderColor = UIColor.gray.cgColor
        image.layer.borderWidth = 10
        image.backgroundColor = .red
        image.clipsToBounds = true
        return image
    }()
    
    fileprivate lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.text = "终于学会分身术一起合照了。可是我还没唱完就跑了，哈哈哈哈哈哈哈哈"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()
    
    fileprivate lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "@芥末"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
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
        
        addSubview(contentLabel)
        contentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalToSuperview().offset(-100)
            make.bottom.equalTo(musicLabel.snp_top).offset(-10)
        }
        
        addSubview(musicImage)
        musicImage.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-10)
            make.width.height.equalTo(50)
            make.right.equalTo(-15)
        }
        
        addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalToSuperview().offset(-100)
            make.bottom.equalTo(contentLabel.snp_top).offset(-10)
        }
    }
}

// MARK:- Event
extension HomeVideoOperationView {
    
}
