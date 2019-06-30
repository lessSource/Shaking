//
//  PhotosChooseCollectionViewCell.swift
//  ImitationShaking
//
//  Created by Lj on 2019/6/25.
//  Copyright © 2019 study. All rights reserved.
//

import UIKit

class PhotosChooseCollectionViewCell: UICollectionViewCell {
    
    public lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    public lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 11)
        return label
    }()
    
    public lazy var selectButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(R.image.iocn_album_nor(), for: .normal)
        return button
    }()
    
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
        contentView.addSubview(timeLabel)
        contentView.addSubview(selectButton)
        
        imageView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.top.left.equalToSuperview()
        }
        
        timeLabel.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-8)
            make.right.equalToSuperview().offset(-8)
        }
        
        selectButton.snp.makeConstraints { (make) in
            make.height.width.equalTo(30)
            make.top.equalTo(3)
            make.right.equalToSuperview().offset(-5)
        }
    }
}
