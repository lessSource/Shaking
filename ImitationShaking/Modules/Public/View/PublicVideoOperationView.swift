//
//  PublicVideoOperationView.swift
//  ImitationShaking
//
//  Created by Lj on 2019/6/18.
//  Copyright © 2019 study. All rights reserved.
//

import UIKit

class PublicVideoOperationView: UIView {
    
    // 摄像按钮
    fileprivate lazy var takingView: UIView = {
        let view = UIView(frame: CGRect(x: Constant.screenWidth/2 - 35, y: Constant.screenHeight - 120, width: 70, height: 70))
        view.layer.cornerRadius = 35
        view.isUserInteractionEnabled = true
        view.backgroundColor = UIColor.withHex(hexString: "#E7445A")
        return view
    }()
    
    // 圆环
    fileprivate lazy var ringView: TakingRingView = {
        let view = TakingRingView(frame: CGRect(x: 0, y: 0, width: 85, height: 85))
        view.center = takingView.center
        return view
    }()
    
    // 进度条
    fileprivate lazy var progressView: PublicVideoProgressView = {
        let progressView = PublicVideoProgressView(frame: CGRect(x: 5, y: 5, width: Constant.screenWidth - 10, height: 5))
        return progressView
    }()
    
    // 翻转
    fileprivate lazy var flipButtonView: OperationButtonView = {
        let buttonView = OperationButtonView()
        return buttonView
    }()
    
    // 快慢速
    fileprivate lazy var speedButtonView: OperationButtonView = {
        let buttonView = OperationButtonView()
        return buttonView
    }()
    
    // 滤镜
    fileprivate lazy var filterButtonView: OperationButtonView = {
        let buttonView = OperationButtonView()
        return buttonView
    }()
    
    // 美化
    fileprivate lazy var beautifyButtonView: OperationButtonView = {
        let buttonView = OperationButtonView()
        return buttonView
    }()
    
    // 倒计时
    fileprivate lazy var countdownButtonView: OperationButtonView = {
        let buttonView = OperationButtonView()
        return buttonView
    }()
    
    // 更多
    fileprivate lazy var moreButtonView: OperationButtonView = {
        let buttonView = OperationButtonView()
        return buttonView
    }()
    
    // 按钮状态
    fileprivate(set) var isTakingState: Bool = false
    
    deinit {
        print("PublicVideoOperationView + 释放")
    }
    
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
        addSubview(progressView)
        addSubview(ringView)
        addSubview(takingView)
        
        let cancleButton = UIButton(frame: CGRect(x: 15, y: progressView.frame.maxY + 20, width: 25, height: 25))
        cancleButton.addTarget(self, action: #selector(cancleButtonClick), for: .touchUpInside)
        cancleButton.setBackgroundImage(R.image.icon_fork(), for: .normal)
        addSubview(cancleButton)
        
        let stackView: UIStackView = UIStackView(arrangedSubviews: [flipButtonView, speedButtonView, filterButtonView, beautifyButtonView, countdownButtonView, moreButtonView])
        stackView.frame = CGRect(x: Constant.screenWidth - 60, y: progressView.frame.maxY + 20, width: 50, height: 360)
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        addSubview(stackView)

        
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
        
        // 捏合手势
        let pichGesture: UIPinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(pichGestureClick(_ :)))
        addGestureRecognizer(pichGesture)
        
        // 播放按钮长按
        let takingLongGesture: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(takingLongGestureClick(_ :)))
        
        // 播放按钮点击
        let takingTagGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(takingTagGestureClick))
        takingView.addGestureRecognizer(takingLongGesture)
        takingView.addGestureRecognizer(takingTagGesture)

    }
    
    // MARK: - Event
    // 屏幕点击
    @objc fileprivate func tapGestureClick() {
        print("tapGestureClick")
    }
    
    // 屏幕左右滑动
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
    
    // 屏幕捏合
    @objc fileprivate func pichGestureClick(_ gesture: UIPinchGestureRecognizer) {
        print(gesture.scale)
        print(gesture.velocity)
    }
    
    // 播放按钮长按
    @objc fileprivate func takingLongGestureClick(_ sender: UILongPressGestureRecognizer) {
        print("longTapClick")
        switch sender.state {
        case .began: break
        case .changed: break
        case .ended: break
        default: break
        }
    }
    
    // 播放按钮点击
    @objc fileprivate func takingTagGestureClick() {
        takingAnimation()
    }
    
    // 取消
    @objc fileprivate func cancleButtonClick() {
        viewController()?.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - public
    public func takingAnimation() {
        if isTakingState {
            takingAnimation(0.5, radius: 5, forKey: "startAnimationKey")
        }else {
            takingAnimation(1, radius: 35, forKey: "endAnimationKey")
        }
        isTakingState = !isTakingState
    }
    
    // MARK: - fileprivate
    // 按钮动画
    fileprivate func takingAnimation(_ scale: CGFloat, radius: CGFloat, forKey: String) {
        let groupAnimation = CAAnimationGroup()
        groupAnimation.duration = 0.3
        groupAnimation.repeatCount = 1
        groupAnimation.isRemovedOnCompletion = false
        groupAnimation.fillMode = .forwards
        
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.toValue = scale
        let radiusAnimation = CABasicAnimation(keyPath: "cornerRadius")
        radiusAnimation.toValue = radius
        groupAnimation.animations = [scaleAnimation, radiusAnimation]
        
        takingView.layer.add(groupAnimation, forKey: forKey)
    }
    
    // 圆环动画
    fileprivate func ringAnimation() {
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.toValue = 1.2
        scaleAnimation.isRemovedOnCompletion = false
        scaleAnimation.fillMode = .forwards
        ringView.layer.add(scaleAnimation, forKey: "ringView")
        
        self.ringView.lineWidth = 20
    }
}


class OperationButtonView: UIView {
    
    public var iconImage: UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    public var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.white
        return label
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
        addSubview(iconImage)
        addSubview(nameLabel)
        iconImage.backgroundColor = .red
        nameLabel.text = "翻转"
        
        iconImage.snp.makeConstraints { (make) in
            make.top.equalTo(5)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(35)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(iconImage.snp_bottom).offset(2)
        }
    }
}
