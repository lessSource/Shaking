//
//  HomeCollectionViewCell.swift
//  ImitationShaking
//
//  Created by Lj on 2019/5/26.
//  Copyright © 2019 study. All rights reserved.
//

import UIKit
import SnapKit

class HomeCollectionViewCell: UICollectionViewCell {
 
    fileprivate lazy var operationView: HomeVideoOperationView = {
        let view = HomeVideoOperationView()
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- layout
    fileprivate func layoutView() {
        contentView.addSubview(operationView)
        operationView.snp.makeConstraints { (make) in
            make.top.equalTo(Constant.navbarAndStatusBar)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(contentView.snp_bottom).offset(-Constant.bottomBarHeight)
        }
    }
    
}
