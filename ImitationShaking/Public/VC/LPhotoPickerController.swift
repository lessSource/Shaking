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
    
    public var pickerModel: LAlbumPickerModel?
    
    fileprivate lazy var navView: LImageNavView = {
        let navView = LImageNavView(frame: CGRect(x: 0, y: 0, width: Constant.screenWidth, height: Constant.navbarAndStatusBar))
        navView.titleLabel.text = "相机胶卷"
        navView.backgroundColor = UIColor.white
        return navView
    }()
    
    fileprivate lazy var tabBarView: LImageTabBarView = {
        let barView: LImageTabBarView = LImageTabBarView(frame: CGRect(x: 0, y: self.collectionView.frame.maxY, width: Constant.screenHeight, height: Constant.bottomBarHeight))
        barView.backgroundColor = UIColor.white
        return barView
    }()
    
    fileprivate lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 1
        flowLayout.minimumInteritemSpacing = 1
        flowLayout.itemSize = CGSize(width: (Constant.screenWidth - 3)/4, height: (Constant.screenWidth - 3)/4)
        
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: Constant.navbarAndStatusBar, width: Constant.screenWidth, height: Constant.screenHeight - Constant.navbarAndStatusBar - Constant.bottomBarHeight), collectionViewLayout: flowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.white
        return collectionView
    }()
    
    fileprivate var dataArray = [LAssetModel]()
    
    deinit {
        print("++++++++释放", self)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        view.addSubview(navView)
        view.addSubview(collectionView)
        view.addSubview(tabBarView)
        collectionView.register(LImagePickerCell.self, forCellWithReuseIdentifier: LImagePickerCell.identifire)
        loadData()
    }
    
    func loadData() {
        LImagePickerManager.shared.getPhotoAlbumMedia(fetchResult: pickerModel?.fetchResult) { (data) in
            self.dataArray = data
            if let model = self.pickerModel {
                self.navView.titleLabel.text = "\(model.title)(\(data.count))"
            }else {
                self.navView.titleLabel.text = "相机胶卷(\(data.count))"
            }
            self.checkSelectedModels()
            self.collectionView.reloadData()
            self.collectionView.scrollToItem(at: IndexPath(item: data.count - 1, section: 0), at: .bottom, animated: false)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    fileprivate func checkSelectedModels() {
        guard let navVC = navigationController as? LImagePickerController else { return }
        dataArray = dataArray.map {
            var model = $0
            model.isSelect = navVC.selectArray.contains(where: {$0.asset == model.asset})
            return model
        }
    }
    
    
    fileprivate func didSelectCellButton(_ isSelect: Bool, indexPath: IndexPath) {
        dataArray[indexPath.item].isSelect = isSelect
        guard let navVC = navigationController as? LImagePickerController else {
            return
        }
        
        if isSelect {
            navVC.selectArray.append(dataArray[indexPath.item])
        }else {
            navVC.selectArray.removeAll(where: { $0.asset.localIdentifier == dataArray[indexPath.item].asset.localIdentifier })
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
        cell.assetModel = dataArray[indexPath.item]
        cell.didSelectButtonClosure = { [weak self] select in
            self?.didSelectCellButton(select, indexPath: indexPath)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        navView.allNumber = 1
        if dataArray[indexPath.item].asset.mediaType == .image {
            guard let cell = collectionView.cellForItem(at: indexPath) as? LImagePickerCell else { return }
            animationDelegate = ModelAnimationDelegate(originalView: cell.imageView)
            //            animationDelegate = ModelAnimationDelegate(superView: cell.superview, currentIndex: indexPath.item)
            showImage(dataArray, currentIndex: indexPath.item, delegate: animationDelegate)
        }
    }
}
