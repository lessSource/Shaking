//
//  PublicPictureEditViewController.swift
//  ImitationShaking
//
//  Created by Lj on 2019/6/27.
//  Copyright © 2019 study. All rights reserved.
//

import UIKit
import Photos

class PublicPictureEditViewController: BaseViewController {

    public var imageAsset: PHAsset?
    
    
    // 旋转裁剪
    fileprivate lazy var tailoringButtonView: OperationButtonView = {
        let buttonView = OperationButtonView()
        buttonView.delegate = self
        buttonView.nameLabel.text = OperationButtonType.tailoring.rawValue
        buttonView.iconImage.image = R.image.icon_tailoring()
        return buttonView
    }()
    
    // 滤镜
    fileprivate lazy var filterButtonView: OperationButtonView = {
        let buttonView = OperationButtonView()
        buttonView.delegate = self
        buttonView.nameLabel.text = OperationButtonType.filter.rawValue
        buttonView.iconImage.image = R.image.icon_filter()
        return buttonView
    }()
    
    // 表情
    fileprivate lazy var expressionButtonView: OperationButtonView = {
        let buttonView = OperationButtonView()
        buttonView.delegate = self
        buttonView.nameLabel.text = OperationButtonType.expression.rawValue
        buttonView.iconImage.image = R.image.icon_expression()
        return buttonView
    }()
    
    fileprivate lazy var nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("下一歩", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.layer.cornerRadius = 2
        button.backgroundColor = UIColor.red
        return button
    }()
    
    fileprivate var currentImage: UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    // MARK: - initView
    fileprivate func initView() {
        currentImage.frame = view.bounds
        currentImage.contentMode = .scaleAspectFit
        view.addSubview(currentImage)
        
        let bottomView = UIView(frame: CGRect(x: 0, y: Constant.screenHeight - Constant.bottomBarHeight - 60, width: Constant.screenWidth, height: Constant.bottomBarHeight + 60))
        view.addSubview(bottomView)
        
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.withHex(hexString: "#FFFFFF", alpha: 0.0).cgColor,UIColor.withHex(hexString: "#000000", alpha: 0.6).cgColor]
        gradientLayer.locations = [0.1, 1.0]
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 0)
        gradientLayer.frame = bottomView.frame
        bottomView.layer.insertSublayer(gradientLayer, above: gradientLayer)

        let stackView: UIStackView = UIStackView(arrangedSubviews: [tailoringButtonView, filterButtonView, expressionButtonView])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        view.addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.bottom.equalTo(-10 - Constant.barMargin)
            make.width.equalTo(180)
            make.height.equalTo(70)
        }
        
        view.addSubview(nextButton)
        nextButton.addTarget(self, action: #selector(nextButtonClick), for: .touchUpInside)
        nextButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(-Constant.barMargin - 15)
            make.right.equalTo(-15)
            make.height.equalTo(35)
            make.width.equalTo(70)
        }
        
        let imageManager: PHCachingImageManager = PHCachingImageManager()
        let option: PHImageRequestOptions = PHImageRequestOptions()
        option.resizeMode = .fast
        option.isSynchronous = true
        option.isNetworkAccessAllowed = true
        guard let asset = imageAsset else {
            return;
        }
        imageManager.requestImage(for: asset, targetSize: view.size, contentMode: .aspectFill, options: option) { (image, dic) in
            self.currentImage.image = image
        }
    }

    
    @objc fileprivate func nextButtonClick() {
        let releaseVC = PublicReleaseViewController()
        navigationController?.pushViewController(releaseVC, animated: true)
    }
}


extension PublicPictureEditViewController: OperationButtonDelegate {
    func operationButtonView(_ type: OperationButtonType, buttonView: OperationButtonView) {
        print(type.rawValue)
    }
}
