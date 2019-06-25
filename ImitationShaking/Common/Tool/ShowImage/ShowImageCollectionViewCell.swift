//
//  ShowImageCollectionViewCell.swift
//  ImitationShaking
//
//  Created by Lj on 2019/6/25.
//  Copyright © 2019 study. All rights reserved.
//

import UIKit

class ShowImageCollectionViewCell: UICollectionViewCell, UIScrollViewDelegate {
    
    enum ActionEnum {
        case tap       // 点击
        case long      // 长按
    }
    
    typealias actionClosure = (_ actionType: ActionEnum) -> Void
    
    private(set) lazy var currentImage = UIImageView()
    public lazy var scrollView = UIScrollView()
    private(set) var action: actionClosure?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func layoutView() {
        scrollView.frame = contentView.bounds
        scrollView.width -= 20
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 3
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        contentView.addSubview(scrollView)
        
        currentImage.contentMode = .scaleAspectFit
        currentImage.frame = scrollView.bounds
        currentImage.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        currentImage.addGestureRecognizer(tapGesture)

        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(longAction))
        currentImage.addGestureRecognizer(longGesture)
        
        let doubleGesture = UITapGestureRecognizer(target: self, action: #selector(ShowImageCollectionViewCell.doubleGestureClick(_ :)))
        doubleGesture.numberOfTapsRequired = 2;
        currentImage.addGestureRecognizer(doubleGesture)
        tapGesture.require(toFail: doubleGesture)
        
        scrollView.addSubview(currentImage)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return currentImage
    }
    
    func imageClick(action: @escaping actionClosure) {
        self.action = action
    }
    
    // 点击
    @objc func tapAction() {
        guard let action = action else { return }
        action(.tap)
    }
    /** 长按 */
    @objc func longAction() {
        guard let action = action else { return }
        action(.long)
    }
    /** 双击 */
    @objc func doubleGestureClick(_ gestureRecognizer: UITapGestureRecognizer) {
        if scrollView.zoomScale > 1 {
            scrollView.setZoomScale(1, animated: true)
        }else {
            let touchPoint = gestureRecognizer.location(in: currentImage)
            let newZoomScale = scrollView.maximumZoomScale
            let sizeX = scrollView.frame.width / newZoomScale
            let sizeY = scrollView.frame.height / newZoomScale
            scrollView .zoom(to: CGRect(x: touchPoint.x - sizeX / 2, y: touchPoint.y - sizeY / 2, width: sizeX, height: sizeY), animated: true)
            
        }
    }
}
