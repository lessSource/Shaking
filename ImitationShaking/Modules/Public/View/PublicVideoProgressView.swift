//
//  PublicVideoProgressView.swift
//  ImitationShaking
//
//  Created by Lj on 2019/6/15.
//  Copyright © 2019 study. All rights reserved.
//

import UIKit

class PublicVideoProgressView: UIView {
    
    // 进度  0 ~ 1
    public var progress: CGFloat = 0.0 {
        didSet {
            progressView(progress)
        }
    }
    
    fileprivate var progressView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.mainColor
        return view
    }()
    
    fileprivate var viewArray: Array = [UIView]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        layoutView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = height/2
    }
    
    // MARK: - layoutView
    fileprivate func layoutView() {
        progressView.frame = CGRect(x: 0, y: 0, width: 0, height: height)
        addSubview(progressView)
    }
    
    public func suspensionProportion() {
        let view = UIView(frame: CGRect(x: progressView.width - 2, y: 0, width: 2, height: height))
        view.backgroundColor = UIColor.white
        addSubview(view)
        viewArray.append(view)
    }
    
    fileprivate func progressView(_ proportion: CGFloat) {
        var pro = proportion
        pro = pro < 0 ? 0 : pro
        pro = pro > 1 ? 1 : pro
        progressView.width = pro * width
    }
    
}
