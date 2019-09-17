//
//  ShowImageCollectionViewCell.swift
//  ImitationShaking
//
//  Created by Lj on 2019/6/25.
//  Copyright © 2019 study. All rights reserved.
//

import UIKit
import Photos
import PhotosUI

class ShowImageCollectionViewCell: UICollectionViewCell, UIScrollViewDelegate {
    
    enum ActionEnum {
        case tap    // 点击
        case long   // 长按
        case play   // 视频播放
    }
    
    typealias actionClosure = (_ actionType: ActionEnum) -> Void
    
    public var isLivePhoto: Bool = false
    
    private(set) var action: actionClosure?

    private(set) var imageRequestID: PHImageRequestID?
    
    private(set) var assetIdentifier: String = ""
    
    private var livePhotoPlay: Bool = false
    
    fileprivate var asset: PHAsset?
    
    public lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.frame = contentView.bounds
        scrollView.width -= 20
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 3
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    public lazy var currentImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.frame = self.scrollView.bounds
        image.isUserInteractionEnabled = true
        return image
    }()

    fileprivate lazy var livePhoto: PHLivePhotoView = {
        let livePhoto = PHLivePhotoView()
        livePhoto.contentMode = .scaleAspectFit
        livePhoto.frame = self.scrollView.bounds
        livePhoto.delegate = self
        return livePhoto
    }()
    
    fileprivate lazy var playerButton: UIButton = {
        let button = UIButton(frame: CGRect(x: Constant.screenWidth/2 - 25, y: Constant.screenHeight/2 - 25, width: 80, height: 80))
        button.setImage(R.image.icon_video(), for: .normal)
        button.isHidden = true
        return button
    }()
    
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
        contentView.addSubview(scrollView)
        scrollView.addSubview(currentImage)
        scrollView.addSubview(playerButton)
        scrollView.addSubview(livePhoto)
        
        playerButton.addTarget(self, action: #selector(playerButtonClick), for: .touchUpInside)
        addGesture()
    }
    
    // MARK:- Gesture
    fileprivate func addGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        currentImage.addGestureRecognizer(tapGesture)
        
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(longGestureClick(_ :)))
        currentImage.addGestureRecognizer(longGesture)
        
        let doubleGesture = UITapGestureRecognizer(target: self, action: #selector(ShowImageCollectionViewCell.doubleGestureClick(_ :)))
        doubleGesture.numberOfTapsRequired = 2;
        currentImage.addGestureRecognizer(doubleGesture)
        tapGesture.require(toFail: doubleGesture)
        
        livePhoto.playbackGestureRecognizer.addTarget(self, action: #selector(playbackGesture))
    }
    
    
    // MARK:- Event
    // 点击
    @objc func tapAction() {
        guard let action = action else { return }
        action(.tap)
    }
    /** 长按 */
    @objc func longGestureClick(_ gestureRecognizer: UILongPressGestureRecognizer) {
        guard let action = action else { return }
        if gestureRecognizer.state == .began {
            action(.long)
            playLivePhoto()
        }
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
            scrollView.zoom(to: CGRect(x: touchPoint.x - sizeX / 2, y: touchPoint.y - sizeY / 2, width: sizeX, height: sizeY), animated: true)
        }
    }
    
    @objc func playerButtonClick() {
        if let action = self.action {
            action(.play)
        }
    }
    
    /** LivePhoto */
    @objc func playbackGesture() {
        print("playbackGesture")
    }
    
    // MARK:- public
    public func updateImage(imageData: LMediaResourcesModel) {
        let start = CACurrentMediaTime()
        livePhoto.isHidden = true
        
        if let image = imageData.dataProtocol as? UIImage {
            currentImage.image = image
        }else if let asset = imageData.dataProtocol as? PHAsset {
            loadImage(asset)
        }else if let string = imageData.dataProtocol as? String {
            print(string)
        }
        playerButton.isHidden = imageData.dateEnum != .video
        let end = CACurrentMediaTime()
        print("方法耗时为：\(end-start)")
    }
    
    public func imageClick(action: @escaping actionClosure) {
        self.action = action
    }

    // MARK:- fileprivate
    fileprivate func loadImage(_ asset: PHAsset) {
        if livePhotoPlay { livePhoto.stopPlayback() }
        self.asset = asset
        assetIdentifier = asset.localIdentifier
        let option: PHImageRequestOptions = PHImageRequestOptions()
        option.resizeMode = .fast
        option.isSynchronous = false
        option.isNetworkAccessAllowed = true
        option.deliveryMode = .highQualityFormat
        var size: CGSize = .zero
        let height: CGFloat = CGFloat(asset.pixelHeight) / CGFloat(asset.pixelWidth) * Constant.screenWidth
        size = CGSize(width: Constant.screenWidth, height: height)
        let imageRequestID = PHCachingImageManager().requestImage(for: asset, targetSize: size, contentMode: .aspectFill, options: option) { (image, dic) in
            if self.assetIdentifier == asset.localIdentifier {
                self.currentImage.image = image
            }else {
                if let requestId = self.imageRequestID {
                    PHCachingImageManager().cancelImageRequest(requestId)
                }
            }
        }
        if let requestId = self.imageRequestID, requestId != imageRequestID {
            PHCachingImageManager().cancelImageRequest(requestId)
        }
        self.imageRequestID = imageRequestID
    }
    
    fileprivate func playLivePhoto() {
        if livePhotoPlay { return }
        guard let asset = self.asset else { return }
        if scrollView.zoomScale > 1 {
            scrollView.setZoomScale(1, animated: true)
        }
        assetIdentifier = asset.localIdentifier
        livePhoto.isHidden = false
        let option: PHLivePhotoRequestOptions = PHLivePhotoRequestOptions()
        option.isNetworkAccessAllowed = true
        option.deliveryMode = .highQualityFormat
        var size: CGSize = .zero
        let height: CGFloat = CGFloat(asset.pixelHeight) / CGFloat(asset.pixelWidth) * Constant.screenWidth
        size = CGSize(width: Constant.screenWidth, height: height)
        let imageRequestID = PHCachingImageManager().requestLivePhoto(for: asset, targetSize: size, contentMode: .aspectFill, options: option) { (livePhoto, dic) in
            if self.assetIdentifier == asset.localIdentifier {
                self.livePhoto.livePhoto = livePhoto
                if !self.livePhotoPlay {
                    self.livePhoto.startPlayback(with: .full)
                }
            }else {
                if let requestId = self.imageRequestID {
                    PHCachingImageManager().cancelImageRequest(requestId)
                }
            }
        }
        if let requestId = self.imageRequestID, requestId != imageRequestID {
            PHCachingImageManager().cancelImageRequest(requestId)
        }
        self.imageRequestID = imageRequestID
    }
}


extension ShowImageCollectionViewCell: PHLivePhotoViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        if livePhotoPlay {
            return livePhoto
        }
        return currentImage
    }
    
    func livePhotoView(_ livePhotoView: PHLivePhotoView, willBeginPlaybackWith playbackStyle: PHLivePhotoViewPlaybackStyle) {
        livePhoto.isHidden = false
        livePhotoPlay = true
    }
    
    func livePhotoView(_ livePhotoView: PHLivePhotoView, didEndPlaybackWith playbackStyle: PHLivePhotoViewPlaybackStyle) {
        livePhoto.isHidden = true
        livePhotoPlay = false
    }
}
