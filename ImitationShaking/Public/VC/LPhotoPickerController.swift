//
//  LPhotoPickerController.swift
//  ImitationShaking
//
//  Created by Lj on 2019/8/26.
//  Copyright © 2019 study. All rights reserved.
//

import UIKit
import Photos

class LPhotoPickerController: UIViewController {

    fileprivate var animationDelegate: ModelAnimationDelegate?
    
    fileprivate lazy var navView: LImageNavView = {
        let navView = LImageNavView(frame: CGRect(x: 0, y: 0, width: Constant.screenWidth, height: Constant.navbarAndStatusBar))
        navView.titleLabel.text = "相机胶卷"
        navView.backgroundColor = UIColor.white
        return navView
    }()
    
    fileprivate lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 1
        flowLayout.minimumInteritemSpacing = 1
        flowLayout.itemSize = CGSize(width: (Constant.screenWidth - 3)/4, height: (Constant.screenWidth - 3)/4)
        
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: self.navView.height, width: Constant.screenWidth, height: Constant.screenHeight - self.navView.height), collectionViewLayout: flowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.white
        return collectionView
    }()
    
    fileprivate var dataArray = [PHAsset]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        reuquetsPhotosAuthorization()
        view.addSubview(navView)
        view.addSubview(collectionView)
        collectionView.register(LImagePickerCell.self, forCellWithReuseIdentifier: LImagePickerCell.identifire)
        loadData()
    }
    
    func loadData() {
        LImagePickerManager.shared.getPhotoAlbumMedia() { (data) in
            self.dataArray = data
            self.navView.titleLabel.text = "相机胶卷(\(data.count))"
            self.collectionView.reloadData()
        }
    }
    
    private func reuquetsPhotosAuthorization() {
        if !LImagePickerManager.shared.reuquetsPhotosAuthorization() {
            collectionView.placeholderShow(true) { (promptView) in
                promptView.imageName(R.image.icon_permissions.name)
                promptView.title("请在iPhone的\'设置-隐私-照片'选项中\r允许\(App.appName)访问你的手机相册")
                promptView.titleLabel.height = 60
                promptView.imageTop(Constant.screenHeight/2 - 150)
                promptView.delegate = self
            }
        }
    }
}

extension LPhotoPickerController: PromptViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource,UIViewControllerTransitioningDelegate, ShowImageProtocol {
    func promptViewImageClick(_ promptView: PromptView) {
        if let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: LImagePickerCell = collectionView.dequeueReusableCell(withReuseIdentifier: LImagePickerCell.identifire, for: indexPath) as! LImagePickerCell
        cell.backgroundColor = UIColor.orange
        let width = (Constant.screenWidth - 3)/4
        LImagePickerManager.shared.getPhotoWithAsset(dataArray[indexPath.item], photoWidth: width) { (image, dic) in
            cell.imageView.image = image
        }
        cell.backView.isHidden = dataArray[indexPath.row].mediaType == .image
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        navView.allNumber = 1
        if dataArray[indexPath.item].mediaType == .image {
            guard let cell = collectionView.cellForItem(at: indexPath) as? LImagePickerCell else { return }
            animationDelegate = ModelAnimationDelegate(originalView: cell.imageView)
            //            animationDelegate = ModelAnimationDelegate(superView: cell.superview, currentIndex: indexPath.item)
            showImage(dataArray, currentIndex: indexPath.item, delegate: animationDelegate)
        }
    }
}
