//
//  PublicVideoOperationView.swift
//  ImitationShaking
//
//  Created by Lj on 2019/6/18.
//  Copyright © 2019 study. All rights reserved.
//

import UIKit

class PublicVideoOperationView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LayoutView
    fileprivate func layoutView() {
        addGestureRecognizer()
    }
    
    // MARK: - GestureRecognizer
    fileprivate func addGestureRecognizer() {
        // 点击
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGestureClick))
        addGestureRecognizer(tapGesture)
        
        // 左右滑动
        let leftSwipeGesture: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeGestureClick(_ :)))
        leftSwipeGesture.direction = .left
        addGestureRecognizer(leftSwipeGesture)
        
        let rightSwipeGesture: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeGestureClick(_ :)))
        addGestureRecognizer(rightSwipeGesture)

    }
    
    // MARK: - Event
    @objc fileprivate func tapGestureClick() {
        print("tapGestureClick")
    }
    
    @objc fileprivate func swipeGestureClick(_ gesture: UISwipeGestureRecognizer) {
        print(gesture.direction)
        switch gesture.direction {
        case .left:
            print("swipeGestureClickLeft")
        case .right:
            print("swipeGestureClickRight")
        default:
            print("default")
        }
    }
    
}
