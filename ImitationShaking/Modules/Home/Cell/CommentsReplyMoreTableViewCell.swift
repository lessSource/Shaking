//
//  CommentsReplyMoreTableViewCell.swift
//  ImitationShaking
//
//  Created by less on 2019/6/3.
//  Copyright © 2019 study. All rights reserved.
//

import UIKit

class CommentsReplyMoreTableViewCell: UITableViewCell {

    public lazy var numberLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.textColor_8C8C8C
        label.font = UIFont.systemFont(ofSize: 13)
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = UIColor.clear
        layoutView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- layoutView
    fileprivate func layoutView() {
        contentView.addSubview(numberLabel)
        numberLabel.snp.makeConstraints { (make) in
            make.left.equalTo(85)
            make.top.equalTo(5)
            make.bottom.equalTo(-5)
        }
    }
    
}
