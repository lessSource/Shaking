//
//  PublicVideoOperationView.swift
//  ImitationShaking
//
//  Created by Lj on 2019/6/18.
//  Copyright © 2019 study. All rights reserved.
//

import UIKit


enum OperationButtonType: String {
    case `default`
    case flip = "翻转"
    case speed = "快慢速"
    case filter = "滤镜"
    case beautify = "美化"
    case countdown = "倒计时"
    case shearMusic = "剪音乐"
    case more = "更多"
    case props = "道具"
    case upload = "上传"
    case tailoring = "旋转裁剪"
    case expression = "表情"
}


protocol OperationButtonDelegate: NSObjectProtocol {
    func operationButtonView(_ type: OperationButtonType, buttonView: OperationButtonView)
}

extension OperationButtonDelegate {
    func operationButtonView(_ type: OperationButtonType, buttonView: OperationButtonView) { }
}

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
        buttonView.delegate = self
        buttonView.nameLabel.text = OperationButtonType.flip.rawValue
        return buttonView
    }()
    
    // 快慢速
    fileprivate lazy var speedButtonView: OperationButtonView = {
        let buttonView = OperationButtonView()
        buttonView.delegate = self
        buttonView.nameLabel.text = OperationButtonType.speed.rawValue
        return buttonView
    }()
    
    // 滤镜
    fileprivate lazy var filterButtonView: OperationButtonView = {
        let buttonView = OperationButtonView()
        buttonView.delegate = self
        buttonView.nameLabel.text = OperationButtonType.filter.rawValue
        return buttonView
    }()
    
    // 美化
    fileprivate lazy var beautifyButtonView: OperationButtonView = {
        let buttonView = OperationButtonView()
        buttonView.delegate = self
        buttonView.nameLabel.text = OperationButtonType.beautify.rawValue
        return buttonView
    }()
    
    // 倒计时
    fileprivate lazy var countdownButtonView: OperationButtonView = {
        let buttonView = OperationButtonView()
        buttonView.delegate = self
        buttonView.nameLabel.text = OperationButtonType.countdown.rawValue
        return buttonView
    }()
    
    // 剪音乐
    fileprivate lazy var shearMusicButtonView: OperationButtonView = {
        let buttonView = OperationButtonView()
        buttonView.delegate = self
        buttonView.nameLabel.text = OperationButtonType.shearMusic.rawValue
        return buttonView
    }()
    
    // 更多
    fileprivate lazy var moreButtonView: OperationButtonView = {
        let buttonView = OperationButtonView()
        buttonView.delegate = self
        buttonView.nameLabel.text = OperationButtonType.more.rawValue
        return buttonView
    }()
    
    // 道具
    fileprivate lazy var propsButtonView: OperationButtonView = {
        let buttonView = OperationButtonView()
        buttonView.delegate = self
        buttonView.nameLabel.text = OperationButtonType.props.rawValue
        buttonView.topImage = 10
        return buttonView
    }()
    
    // 上传
    fileprivate lazy var uploadButtonView: OperationButtonView = {
        let buttonView = OperationButtonView()
        buttonView.delegate = self
        buttonView.nameLabel.text = OperationButtonType.upload.rawValue
        buttonView.topImage = 10
        return buttonView
    }()
    
    // 快慢速切换
    fileprivate lazy var speedSegmented: UISegmentedControl = {
        let speedSegmented = UISegmentedControl(items: ["极慢","慢","标准","快","极快"])
        speedSegmented.layer.cornerRadius = 4
        speedSegmented.frame =  CGRect(x: 30, y: self.ringView.y - 50, width: Constant.screenWidth - 60, height: 40)
        speedSegmented.backgroundColor = UIColor(white: 0.0, alpha: 0.3)
        speedSegmented.tintColor = UIColor.white
        speedSegmented.setBackgroundImage(UIImage.colorCreateImage(UIColor.clear, size: speedSegmented.size), for: .normal, barMetrics: .default)
        speedSegmented.setBackgroundImage(UIImage.colorCreateImage(UIColor.clear, size: speedSegmented.size), for: .selected, barMetrics: .default)
        speedSegmented.isHidden = true
        speedSegmented.setDividerImage(UIImage.colorCreateImage(UIColor.clear, size: CGSize(width: 1, height: speedSegmented.height)), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        return speedSegmented
    }()
    
    fileprivate var stackView: UIStackView!
    
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
        addSubview(propsButtonView)
        addSubview(uploadButtonView)
        addSubview(speedSegmented)
        
        speedSegmented.addTarget(self, action: #selector(speedSegmentedClick(_ :)), for: .valueChanged)
        changeSegmentedColor(2)
        speedSegmented.selectedSegmentIndex = 2
        
        let cancleButton = UIButton(frame: CGRect(x: 15, y: progressView.frame.maxY + 20, width: 25, height: 25))
        cancleButton.addTarget(self, action: #selector(cancleButtonClick), for: .touchUpInside)
        cancleButton.setBackgroundImage(R.image.icon_fork(), for: .normal)
        addSubview(cancleButton)
        
        let musicButton: UIButton = UIButton()
        musicButton.setTitle("选择音乐", for: .normal)
        musicButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        musicButton.setTitleColor(.white, for: .normal)
        musicButton.addTarget(self, action: #selector(musicButtonClick), for: .touchUpInside)
        addSubview(musicButton)
        musicButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(cancleButton)
        }
        
        stackView = UIStackView(arrangedSubviews: [flipButtonView, speedButtonView, filterButtonView, beautifyButtonView, countdownButtonView, moreButtonView])
        stackView.frame = CGRect(x: Constant.screenWidth - 60, y: progressView.frame.maxY + 20, width: 50, height: 70 * CGFloat(stackView.arrangedSubviews.count))
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        addSubview(stackView)

        propsButtonView.snp.makeConstraints { (make) in
            make.centerY.equalTo(takingView).offset(15)
            make.left.equalTo(60)
            make.height.equalTo(80)
            make.width.equalTo(50)
        }
        
        uploadButtonView.snp.makeConstraints { (make) in
            make.centerY.equalTo(takingView).offset(15)
            make.right.equalTo(-60)
            make.height.equalTo(80)
            make.width.equalTo(50)
        }
        
        PublicCameraStruct.getPhotoAlbumAFristImage { (image) in
            self.uploadButtonView.iconImage.image = image
        }
        
        PublicCameraStruct.getPhotoAlbumMedia(.image) { (array) in
            print("-----------------------")
            print(array)
            print(array.count)
            print("-----------------------")
        }
        
        PublicCameraStruct.getPhotoAlbumMedia(.video) { (array) in
            print("!!!!!!!!!!!!!!!!!!!!!!!")
            print(array)
            print(array.count)
            print("!!!!!!!!!!!!!!!!!!!!!!!")
        }
        
        PublicCameraStruct.getPhotoAlbumMedia(.audio) { (array) in
            print("```````````````````````")
            print(array)
            print(array.count)
            print("```````````````````````")
        }
        
        PublicCameraStruct.getPhotoAlbumMedia(.unknown) { (array) in
            print("///////////////////////")
            print(array)
            print(array.count)
            print("///////////////////////")
        }

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
    
    // 选择音乐
    @objc fileprivate func musicButtonClick() {
        stackView.insertArrangedSubview(shearMusicButtonView, at: 5)
        stackView.height = CGFloat(70 * stackView.arrangedSubviews.count)
    }
    
    // 快慢速切换
    @objc fileprivate func speedSegmentedClick(_ segmented: UISegmentedControl) {
        changeSegmentedColor(segmented.selectedSegmentIndex)
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
    
    // 切换UISegmented
    fileprivate func changeSegmentedColor(_ selectIndex: Int) {
        let itemArray = speedSegmented.subviews.sorted { $0.x < $1.x }
        print(itemArray)
        for (i, item) in itemArray.enumerated() {
            if i == selectIndex {
                item.backgroundColor = UIColor.white
                item.layer.cornerRadius = 4
            }else {
                item.backgroundColor = UIColor.clear
            }
        }
    }
}

extension PublicVideoOperationView: OperationButtonDelegate {
    func operationButtonView(_ type: OperationButtonType, buttonView: OperationButtonView) {
        print(type.rawValue)
        switch type {
        case .upload:
            let photosChooseVC = PhotoChooseBaseViewController()
            let navVC: BaseNavigationController = BaseNavigationController(rootViewController: photosChooseVC)
            viewController()?.present(navVC, animated: true, completion: nil)
        case .speed:
            speedSegmented.isHidden = !speedSegmented.isHidden
        default: break
        }
        
    }
}



class OperationButtonView: UIView {
    
    public weak var delegate: OperationButtonDelegate?
    
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
    
    public var topImage: CGFloat = 5 {
        didSet {
            nameLabel.snp.updateConstraints { (make) in
                make.top.equalTo(iconImage.snp_bottom).offset(topImage)
            }
        }
    }
    
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
        
        iconImage.isUserInteractionEnabled = true
        let iconImageTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(iconImageClick))
        iconImage.addGestureRecognizer(iconImageTap)
        
        iconImage.snp.makeConstraints { (make) in
            make.top.equalTo(5)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(40)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(iconImage.snp_bottom).offset(topImage)
        }
    }
    
    @objc fileprivate func iconImageClick() {
        guard let name = nameLabel.text else {
            return
        }
        delegate?.operationButtonView(OperationButtonType(rawValue: name) ?? .`default`, buttonView: self)
    }
}
