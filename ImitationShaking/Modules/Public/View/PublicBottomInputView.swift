//
//  PublicBottomInputView.swift
//  ImitationShaking
//
//  Created by Lj on 2019/6/2.
//  Copyright © 2019 study. All rights reserved.
//

import UIKit

protocol PublicInputDelegate: NSObjectProtocol {
    func publicInputView(_ inputView: PublicBottomInputView, textChange text: String, height: CGFloat)
    
    func publicInputView(_ inputView: PublicBottomInputView, sendText text: String)
    
}

extension PublicInputDelegate {
    func publicInputView(_ inputView: PublicBottomInputView, textChange text: String, height: CGFloat) { }
    
    func publicInputView(_ inputView: PublicBottomInputView, sendText text: String) { }
}


class PublicBottomInputView: UIView {
    
    public weak var delegate: PublicInputDelegate?
    
    fileprivate var textMaxHeight: CGFloat = 0
    fileprivate var textHeight: CGFloat = 0

    public lazy var textView: UITextView = {
        let textView = UITextView(frame: CGRect(x: 15, y: 10, width: Constant.screenWidth - 30, height: 30))
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.placeholder = "写句神评论吧"
        textView.textColor = UIColor.white
        textView.placeholderColor = UIColor.withHex(hexString: "8C8C8C")
        textView.backgroundColor = .black
        textView.delegate = self
        textView.returnKeyType = .send
        textView.autoresizingMask = UIView.AutoresizingMask.flexibleHeight
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
        layoutView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- layoutView
    fileprivate func layoutView() {
        addSubview(textView)
        textMaxHeight = (textView.font?.lineHeight ?? 0) * 5.0 + textView.textContainerInset.top + textView.textContainerInset.bottom
    }
}

extension PublicBottomInputView: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        let height = textView.sizeThatFits(CGSize(width: textView.width, height: CGFloat(MAXFLOAT))).height
        if textHeight != height {
            textView.isScrollEnabled = height > textMaxHeight && textMaxHeight > 0
            textHeight = height
            delegate?.publicInputView(self, textChange: textView.text, height: height)
            superview?.layoutIfNeeded()
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            delegate?.publicInputView(self, sendText: textView.text)
            return false
        }
        return true
    }
}
