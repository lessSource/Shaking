//
//  LImagePickerCell.swift
//  ImitationShaking
//
//  Created by less on 2019/8/22.
//  Copyright © 2019 study. All rights reserved.
//

import UIKit

class LImagePickerCell: UICollectionViewCell {
    
    typealias SelectClosure = (Bool) -> ()
    
    public var didSelectButtonClosure: SelectClosure?
    
    public var assetModel: LAssetModel? {
        didSet {
            guard let model = assetModel else {  return }
            selectButton.isSelected  = model.isSelect
            selectImageView.image = model.isSelect ? R.image.iocn_album_sel() : R.image.iocn_album_nor()
            let width = (Constant.screenWidth - 3)/4
            LImagePickerManager.shared.getPhotoWithAsset(model.asset, photoWidth: width) { (image, dic) in
                self.imageView.image = image
            }
            backView.isHidden = model.asset.mediaType == .image
        }
    }
    
    public lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    public lazy var selectImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.image = R.image.iocn_album_nor()
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
    
    public lazy var selectButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(selectButtonClick(_ :)), for: .touchUpInside)
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
        contentView.addSubview(selectImageView)
        contentView.addSubview(selectButton)
        contentView.addSubview(backView)
        
        backView.addSubview(timeLabel)

        imageView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.top.left.equalToSuperview()
        }
        
        selectImageView.snp.makeConstraints { (make) in
            make.height.width.equalTo(24)
            make.right.equalToSuperview().offset(-5)
            make.top.equalTo(5)
        }
        
        timeLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(10)
        }
        
        selectButton.snp.makeConstraints { (make) in
            make.height.width.equalTo(44)
            make.top.right.equalToSuperview()
        }
        
        backView.snp.makeConstraints { (make) in
            make.height.equalTo(18)
            make.left.right.bottom.equalToSuperview()
        }
        
    }
    
    // MARK:- Event
     @objc fileprivate func selectButtonClick(_ sender: UIButton) {
        selectImageView.image = sender.isSelected ? R.image.iocn_album_nor() : R.image.iocn_album_sel()
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            selectImageView.showOscillatoryAnimation()
        }
        if let closure = didSelectButtonClosure {
            closure(sender.isSelected)
        }
        
    }
}
