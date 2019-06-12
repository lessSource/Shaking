//
//  LTitleBarLayout.swift
//  ImitationShaking
//
//  Created by less on 2019/6/12.
//  Copyright © 2019 study. All rights reserved.
//

import UIKit

struct LTitleBarLayout {
    
    // MARK: - 标题栏
    var needBar: Bool = true
    // 标题栏距顶端边距
    var barMarginTop: CGFloat = 0
    // 标题item大小，默认80 * 40
    var barItemSize: CGSize = CGSize(width: 80, height: 40)
    var barBounces: Bool = true
    var barAlwaysBounceHorizontal: Bool = false
    
    // MARK: - 标题栏底线
    var needBarBottomLine: Bool = true
    var barBottomLineColor: UIColor = UIColor.lightGray
    
    // MARK: - 标题栏底部跟踪线
    var beedBarFollowLine: Bool = true
    var barFollowLineColor: UIColor = .orange
    // 跟踪线占item宽的百分比 0~1 之间
    var barFollowLinePercent: CGFloat = 0.6
    
    // MARK: - 文字属性
    var barTextFont: UIFont = UIFont.systemFont(ofSize: 16)
    var barTextSelectedFont: UIFont = UIFont.systemFont(ofSize: 16)
    var barTextColor: UIColor = .black
    var barTextSelectedColor: UIColor = .orange
    
    
}

