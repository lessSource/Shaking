//
//  LAlbumPickerTableViewCell.swift
//  ImitationShaking
//
//  Created by less on 2019/8/27.
//  Copyright © 2019 study. All rights reserved.
//

import UIKit

class LAlbumPickerTableViewCell: UITableViewCell {

    public var albumModel: LAlbumPickerModel = LAlbumPickerModel() {
        didSet {
            nameLabel.text = "\(albumModel.title)(\(albumModel.count))"
            if let asset = albumModel.asset {
                LImagePickerManager.shared.getPhotoWithAsset(asset, photoWidth: 60) { (image, dic) in
                    self.coverImage.image = image
                }
            }
        }
    }
    
    
    fileprivate lazy var coverImage: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    fileprivate lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.groupTableViewBackground
        return view
    }()
    
    fileprivate lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    
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
        accessoryType = .disclosureIndicator
        layoutView()
    }
    

    override func layoutSubviews() {
        super.layoutSubviews()
        
        coverImage.frame = CGRect(x: 0, y: 0, width: bounds.height, height: bounds.height - 1)
        lineView.frame = CGRect(x: coverImage.frame.maxX, y: coverImage.height, width: Constant.screenWidth - coverImage.width, height: 1)
        nameLabel.frame = CGRect(x: coverImage.width + 10, y: 20, width: contentView.width - coverImage.width - 20, height: bounds.height - 40)
    }
    
    // MARK:- layoutView
    fileprivate func layoutView() {
        contentView.addSubview(coverImage)
        contentView.addSubview(lineView)
        contentView.addSubview(nameLabel)
        coverImage.backgroundColor = UIColor.red
        
    }
}
