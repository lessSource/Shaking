//
//  SharePopUpView.swift
//  ImitationShaking
//
//  Created by less on 2019/5/31.
//  Copyright © 2019 study. All rights reserved.
//

import UIKit

class SharePopUpView: PopUpContentView {

    fileprivate lazy var collection: UICollectionView = {
        let collection = UICollectionView()
        return collection
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 4
        clipsToBounds = true
        backgroundColor = UIColor.popUpColor_2F2F2F
//        layoutView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
