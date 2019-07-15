//
//  LoginViewController.swift
//  ImitationShaking
//
//  Created by less on 2019/6/3.
//  Copyright © 2019 study. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController {

    fileprivate lazy var phoneTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "输入手机号码"
        textField.layer.cornerRadius = 2
        textField.leftViewMode = .always
        textField.textColor = UIColor.white
        textField.backgroundColor = UIColor(white: 1.0, alpha: 0.2)
        textField.keyboardType = UIKeyboardType.numberPad
        textField.setValue(UIColor.withHex(hexString: "#C388F3"), forKeyPath: "placeholderLabel.textColor")
        textField.leftView = leftView(45)
        return textField
    }()
    
    fileprivate lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.layer.cornerRadius = 2
        textField.backgroundColor = UIColor(white: 1.0, alpha: 0.2)
        textField.textColor = UIColor.white
        textField.isSecureTextEntry = true
        textField.placeholder = "输入账号密码"
        textField.setValue(UIColor.withHex(hexString: "#C388F3"), forKeyPath: "placeholderLabel.textColor")
        textField.leftViewMode = .always
        textField.leftView = leftView(45)
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let topColor = UIColor.withHex(hexString: "#B036F0")
        let bottomColor = UIColor.withHex(hexString: "#7866EB", alpha: 0.8)
        let gradientColros = [topColor.cgColor, bottomColor.cgColor]
        // 定义每种颜色的所在的位置
        let gradientLocations: [NSNumber] = [0.0, 1.0]
        // 创建CACradientLayer对象
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColros
        gradientLayer.locations = gradientLocations
        
        gradientLayer.frame = view.frame
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        layoutView()
    }
    
    // MARK:- layoutView
    fileprivate func layoutView() {
        let cancleButton = UIButton()
        cancleButton.setImage(R.image.icon_fork(), for: .normal)
        cancleButton.addTarget(self, action: #selector(cancleButtonClick), for: .touchUpInside)
        cancleButton.hitTestEdgeInsets = UIEdgeInsets(top: -10, left: -10, bottom: -10, right: -10)
        view.addSubview(cancleButton)
        cancleButton.snp.makeConstraints { (make) in
            make.height.width.equalTo(20)
            make.top.equalTo(15 + Constant.statusHeight)
            make.left.equalTo(15)
        }
        
        let promptLabel = UILabel()
        promptLabel.text = "手机号登录有助于您快速找到好友"
        promptLabel.textColor = UIColor.white
        promptLabel.font = UIFont.boldSystemFont(ofSize: 12)
        view.addSubview(promptLabel)
        promptLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(Constant.navbarAndStatusBar + 50)
        }
        
        view.addSubview(phoneTextField)
        phoneTextField.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(promptLabel.snp_bottom).offset(15)
            make.left.equalTo(45)
            make.height.equalTo(45)
        }
        
        view.addSubview(passwordTextField)
        passwordTextField.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(phoneTextField.snp_bottom).offset(5)
            make.left.equalTo(45)
            make.height.equalTo(45)
        }
        
        let loginButton = UIButton()
        loginButton.setTitle("登录", for: .normal)
        loginButton.setTitleColor(UIColor.white, for: .normal)
        loginButton.backgroundColor = UIColor.mainColor
        loginButton.addTarget(self, action: #selector(loginButtonClick), for: .touchUpInside)
        view.addSubview(loginButton)
        loginButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(passwordTextField.snp_bottom).offset(30)
            make.left.equalTo(45)
            make.height.equalTo(45)
        }
        
    }

    fileprivate func leftView(_ height: CGFloat) -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: height))
        return view
    }
    
    // MARK:- Event
    @objc fileprivate func cancleButtonClick() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func loginButtonClick() {
        guard let phone = phoneTextField.text, let password = passwordTextField.text else {
            return
        }
        if phone.isEmpty {
            MBAlertUtil.alertManager.showPromptInfo("请输入手机号")
            return
        }
        if password.isEmpty {
            MBAlertUtil.alertManager.showPromptInfo("请输入账号密码")
            return
        }
        requestLogin()
    }
    
    // MARK:- request
    fileprivate func requestLogin() {
        var params: Dictionary = [String: Any]()
        params.updateValue(phoneTextField.text!, forKey: "phone")
        params.updateValue(passwordTextField.text!, forKey: "password")
        Network.default.request(CommonTargetTypeApi.postRequest(LoginRegisterRequest.login, params,.query), successClosure: { (response) in
            if let model = UserCacheModel.deserialize(from: response.dictionaryObject) {
                LCacheModel.shareInstance.save(model)
                self.dismiss(animated: true, completion: nil)
            }
        }) { (error) in
            
        }
    }
}
