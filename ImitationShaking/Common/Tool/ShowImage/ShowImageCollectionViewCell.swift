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

protocol CurrentViewProtocol { }

extension CurrentViewProtocol where Self : UIView {
    func loadImage(_ asset: PHAsset) { }
}

extension UIImageView : CurrentViewProtocol {
    func loadImage(_ asset: PHAsset) {
        switch asset.mediaSubtypes {
        case .photoPanorama:
            print("photoPanorama")
        case .photoHDR:
            print("photoHDR")
        case .photoScreenshot:
            print("photoScreenshot")
        case .photoLive:
            print("photoLive")
            //        case .photoDepthEffect:
        //            print("photoDepthEffect")
        case .videoStreamed:
            print("videoStreamed")
        case .videoHighFrameRate:
            print("videoHighFrameRate")
        case .videoTimelapse:
            print("videoTimelapse")
        default:
            print("photoDepthEffect")
        }
        
        
        let option: PHImageRequestOptions = PHImageRequestOptions()
        option.resizeMode = .fast
        option.isSynchronous = false
        option.isNetworkAccessAllowed = true
        option.deliveryMode = .highQualityFormat
        var size: CGSize = .zero
        if asset.mediaSubtypes == .photoPanorama {
            let height: CGFloat = CGFloat(asset.pixelHeight) / CGFloat(asset.pixelWidth) * Constant.screenWidth
            size = CGSize(width: Constant.screenWidth, height: height)
        }else {
            size = PHImageManagerMaximumSize
        }
        PHCachingImageManager().requestImage(for: asset, targetSize: size, contentMode: .aspectFill, options: option) { (image, dic) in
//            self.image = image?.drawImageInImage(R.image.icon_music(), watermarkImageRect: CGRect(x: 0, y: 0, width: 40, height: 40))
            self.image = image
        }
    }
}

extension PHLivePhotoView: CurrentViewProtocol {
    func loadImage(_ asset: PHAsset) {
        let option: PHLivePhotoRequestOptions = PHLivePhotoRequestOptions()
        option.isNetworkAccessAllowed = true
        option.deliveryMode = .highQualityFormat
        PHCachingImageManager().requestLivePhoto(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFill, options: option) { (livePhoto, dic) in
            self.livePhoto = livePhoto
        }
    }
}


class ShowImageCollectionViewCell: UICollectionViewCell, UIScrollViewDelegate {
    
    enum ActionEnum {
        case tap       // 点击
        case long      // 长按
    }
    
    typealias actionClosure = (_ actionType: ActionEnum) -> Void
    
    private(set) lazy var currentImage = UIImageView()
    
    public lazy var scrollView = UIScrollView()
    private(set) var action: actionClosure?
    
    fileprivate lazy var livePhoto = PHLivePhotoView()
    
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
        livePhoto.contentMode = .scaleAspectFit
        livePhoto.frame = scrollView.bounds

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        currentImage.addGestureRecognizer(tapGesture)
//        livePhoto.addGestureRecognizer(tapGesture)

        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(longAction))
        currentImage.addGestureRecognizer(longGesture)
        
        let doubleGesture = UITapGestureRecognizer(target: self, action: #selector(ShowImageCollectionViewCell.doubleGestureClick(_ :)))
        doubleGesture.numberOfTapsRequired = 2;
        currentImage.addGestureRecognizer(doubleGesture)
//        livePhoto.addGestureRecognizer(doubleGesture)

        tapGesture.require(toFail: doubleGesture)
        
        scrollView.addSubview(currentImage)
        scrollView.addSubview(livePhoto)

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
            scrollView.zoom(to: CGRect(x: touchPoint.x - sizeX / 2, y: touchPoint.y - sizeY / 2, width: sizeX, height: sizeY), animated: true)
        }
    }
    
    public func updateImage(imageProtocol: ImageDataProtocol) {
        let start = CACurrentMediaTime()
        print("1")
        livePhoto.isHidden = true
//        currentImage.isHidden = true
        if let image = imageProtocol as? UIImage {
            currentImage.image = image
        }else if let asset = imageProtocol as? PHAsset {
            self.currentImage.loadImage(asset)

//            currentImage.image = nil
//            livePhoto.livePhoto = nil
//            if asset.mediaSubtypes == .photoLive {
//                livePhoto.isHidden = false
//                self.livePhoto.loadImage(asset)
//            }else {
//                currentImage.isHidden = false
//                self.currentImage.loadImage(asset)
//            }
        }else if let string = imageProtocol as? String {
            print(string)
        }
        print("3")
        let end = CACurrentMediaTime()
        print("方法耗时为：\(end-start)")
    }
}
