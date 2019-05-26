//
//  BaseTabBar.swift
//  ImitationShaking
//
//  Created by Lj on 2019/5/25.
//  Copyright © 2019 study. All rights reserved.
//

import UIKit

class BaseTabBar: UITabBar {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.barTintColor = .red
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}



