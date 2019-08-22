//
//  LImagePickerController.swift
//  ImitationShaking
//
//  Created by Lj on 2019/8/21.
//  Copyright © 2019 study. All rights reserved.
//

import UIKit
import Photos

class LImagePickerController: UINavigationController {
    
    fileprivate lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 1
        flowLayout.minimumInteritemSpacing = 1
        flowLayout.itemSize = CGSize(width: (Constant.screenWidth - 3)/4, height: (Constant.screenWidth - 3)/4)

        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: flowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.white
        return collectionView
    }()
    
    fileprivate var dataArray = [PHAsset]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setNavigationBarHidden(true, animated: true)
        reuquetsPhotosAuthorization()
        view.addSubview(collectionView)
        collectionView.register(LImagePickerCell.self, forCellWithReuseIdentifier: LImagePickerCell.identifire)
        
        LImagePickerManager.shared.getPhotoAlbumMedia() { (data) in
            self.dataArray = data
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


extension LImagePickerController: PromptViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
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
        return cell
    }
    
}
