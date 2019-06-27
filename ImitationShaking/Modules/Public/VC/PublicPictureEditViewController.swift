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
    
    fileprivate var currentImage: UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        view.bounds
        currentImage.frame = view.bounds
        currentImage.contentMode = .scaleAspectFit
        view.addSubview(currentImage)
        
        let imageManager: PHCachingImageManager = PHCachingImageManager()
        let option: PHImageRequestOptions = PHImageRequestOptions()
        option.resizeMode = .fast
        option.isSynchronous = true
        option.isNetworkAccessAllowed = true
        imageManager.requestImage(for: imageAsset ?? PHAsset(), targetSize: view.size, contentMode: .aspectFill, options: option) { (image, dic) in
            self.currentImage.image = image
        }
    }

}
