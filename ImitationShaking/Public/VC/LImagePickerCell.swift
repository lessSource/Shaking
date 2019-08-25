//
//  LImagePickerCell.swift
//  ImitationShaking
//
//  Created by less on 2019/8/22.
//  Copyright © 2019 study. All rights reserved.
//

import UIKit

class LImagePickerCell: UICollectionViewCell {
    public lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    public lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.text = "12:00"
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 10)
        return label
    }()
    
    public lazy var backView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.7)
        return view
    }()
    
//    public lazy var selectButton: UIButton = {
//        let button = UIButton()
//        button.setBackgroundImage(R.image.iocn_album_nor(), for: .normal)
//        return button
//    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - layoutView
    fileprivate func layoutView() {
        contentView.addSubview(imageView)
//        contentView.addSubview(selectButton)
        contentView.addSubview(backView)
        backView.addSubview(timeLabel)

        imageView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.top.left.equalToSuperview()
        }
        
        timeLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(10)
        }
        
//        selectButton.snp.makeConstraints { (make) in
//            make.height.width.equalTo(30)
//            make.top.equalTo(3)
//            make.right.equalToSuperview().offset(-5)
//        }
        
        backView.snp.makeConstraints { (make) in
            make.height.equalTo(18)
            make.left.right.bottom.equalToSuperview()
        }
    }
}
