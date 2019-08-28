//
//  LImageTabBarView.swift
//  ImitationShaking
//
//  Created by less on 2019/8/27.
//  Copyright © 2019 study. All rights reserved.
//

import UIKit

enum ImageTabBarButtonType {
    /** 完成 */
    case complete
    /** 预览 */
    case preview
}

protocol ImageTabBarViewDelegate: NSObjectProtocol {
    func imageTabBarViewButton(_ buttonType: ImageTabBarButtonType)
}

extension ImageTabBarViewDelegate {
    func imageTabBarViewButton(_ buttonType: ImageTabBarButtonType) { }
}

class LImageTabBarView: UIView {

    public weak var delegate: ImageTabBarViewDelegate?
    
    public var maxCount: Int = 1 {
        didSet {
            previewButton.isHidden = maxCount == 1
        }
    }
    
    public var currentCount: Int = 0 {
        didSet {
            if currentCount == 0 {
                completeButton.setTitle("完成", for: .normal)
                completeButton.isUserInteractionEnabled = false
                previewButton.isUserInteractionEnabled = false
                completeButton.setTitleColor(UIColor(white: 0, alpha: 0.5), for: .normal)
                previewButton.setTitleColor(UIColor(white: 0, alpha: 0.5), for: .normal)
            }else {
                completeButton.setTitle("完成(\(currentCount)/\(maxCount))", for: .normal)
                completeButton.isUserInteractionEnabled = true
                previewButton.isUserInteractionEnabled = true
                completeButton.setTitleColor(UIColor(white: 0, alpha: 1.0), for: .normal)
                previewButton.setTitleColor(UIColor(white: 0, alpha: 1.0), for: .normal)
            }
            completeButton.width = completeButton.titleLabel?.intrinsicContentSize.width ?? 0
            completeButton.x = Constant.screenWidth - 15 - completeButton.width
        }
    }
    
    fileprivate lazy var completeButton: UIButton = {
        let button = UIButton(frame: CGRect(x: Constant.screenWidth - 55, y: 4.5, width: 40, height: 40))
        button.setTitle("完成", for: .normal)
        button.setTitleColor(UIColor(white: 0, alpha: 0.5), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        return button
    }()
    
    fileprivate lazy var previewButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 10, y: 4.5, width: 40, height: 40))
        button.setTitle("预览", for: .normal)
        button.setTitleColor(UIColor(white: 0, alpha: 0.5), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- layoutView
    fileprivate func layoutView() {
        addSubview(completeButton)
        addSubview(previewButton)
        completeButton.addTarget(self, action: #selector(completeButtonClick(_ :)), for: .touchUpInside)
        previewButton.addTarget(self, action: #selector(previewButtonClick(_ :)), for: .touchUpInside)
        let lineView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: Constant.screenWidth, height: 1))
        lineView.backgroundColor = UIColor.groupTableViewBackground
        addSubview(lineView)
    }
    
    // MARK:- Event
    @objc fileprivate func completeButtonClick(_ sender: UIButton) {
        delegate?.imageTabBarViewButton(.complete)
    }
    
    @objc fileprivate func previewButtonClick(_ sender: UIButton) {
        delegate?.imageTabBarViewButton(.preview)
    }
    
}
