//
//  UIView+Placeholder.swift
//  Error
//
//  Created by less on 2019/2/13.
//  Copyright © 2019 lj. All rights reserved.
//

import UIKit

protocol PromptViewDelegate: NSObjectProtocol {
    func promptViewButtonClick(_ promptView: PromptView)
    func promptViewImageClick(_ promptView: PromptView)
}

extension PromptViewDelegate {
    func promptViewButtonClick(_ promptView: PromptView) { }
    func promptViewImageClick(_ promptView: PromptView) { }
}


class PromptView: UIView {
    
    public weak var delegate: PromptViewDelegate?
    
    public lazy var button: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("重新加载", for: .normal)
        button.frame = CGRect(origin: CGPoint(x: (bounds.width - button.intrinsicContentSize.width)/2, y: titleLabel.frame.maxY + 5), size: button.intrinsicContentSize)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.addTarget(self, action: #selector(buttonClick), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: (bounds.width - 120)/2, y: 150, width: 120, height: 120))
        imageView.image = UIImage(named: "follow_empty_icon")
        imageView.clipsToBounds = true
        imageView.contentMode = .center
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    public lazy var titleLabel: UILabel = {
        let title = UILabel(frame: CGRect(x: 15, y: imageView.frame.maxY + 10, width: bounds.width - 30, height: 30))
        title.font = UIFont.systemFont(ofSize: 14)
        title.textColor = UIColor.withHex(hexString: "#666666")
        title.text = "暂无数据"
        title.numberOfLines = 0
        title.textAlignment = .center
        return title
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK:- setUpUI
    private func setUpUI() {
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(button)
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageClick))
        imageView.addGestureRecognizer(tapGesture)
    }
    
    fileprivate func titleFrame() {
        var frame: CGRect = titleLabel.frame
        frame.origin.y = imageView.frame.maxY + 10
        titleLabel.frame = frame
        var buttonFrame: CGRect = button.frame
        buttonFrame.origin.y = titleLabel.frame.maxY + 5
        button.frame = buttonFrame
    }
    
    // MARK:- public
    /** 占位view的位置 */
    public func viewFrame(_ frame: CGRect) {
        self.frame = frame
    }
    /** 占位图片位置 */
    public func imageFrame(_ frame: CGRect) {
        imageView.frame = frame
        titleFrame()
    }
    /** 占位图片 */
    public func imageName(_ image: String) {
        imageView.image = UIImage(named: image)
    }
    /** 图片距上位置 */
    public func imageTop(_ top: CGFloat) {
        var frame: CGRect = imageView.frame
        frame.origin.y = top
        imageView.frame = frame
        titleFrame()
    }
    /** 提示文字 */
    public func title(_ title: String) {
        titleLabel.text = title
    }
    /** 提示文字大小 */
    public func titleFont(_ font: UIFont) {
        titleLabel.font = font
    }
    /** 提示文字颜色 */
    public func titleColor(_ color: UIColor) {
        titleLabel.textColor = color
    }
    /** button显示 */
    public func isButtonHidden(_ hidden: Bool) {
        button.isHidden = hidden
    }
    
    // MARK:- Event
    @objc func buttonClick() {
        delegate?.promptViewButtonClick(self)
    }
    @objc func imageClick() {
        delegate?.promptViewImageClick(self)
    }
}

extension UIView {
    
    typealias ViewBlock = (_ view: PromptView) -> ()
    
    func placeholderShow(_ show: Bool,_ viewBlock: ViewBlock? = nil) {
        if show {
            showPromptView()
            if let block = viewBlock {
                block(promptView)
            }
        }else {
            promptView.removeFromSuperview()
        }
    }
    
    // MARK:- private
    private func showPromptView() {
        if self.subviews.count > 0 {
            var t_v = self
            for v in self.subviews {
                if v.isKind(of: UITableView.self) {
                    t_v = v
                }
            }
            t_v.insertSubview(promptView, aboveSubview: t_v.subviews[0])
            promptView.backgroundColor = t_v.backgroundColor
        }else {
            self.addSubview(promptView)
        }
    }
    
    private struct AssociatedKeys {
        static var PromptViewKey: String = "PromptViewKey"
    }
    
    private var promptView: PromptView {
        get {
            guard let view = objc_getAssociatedObject(self, &AssociatedKeys.PromptViewKey) as? PromptView else {
                return generatePromptView()
            }
            return view
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.PromptViewKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    private func generatePromptView() -> PromptView {
        let view: PromptView = PromptView(frame: bounds)
        promptView = view
        return view
    }
}

