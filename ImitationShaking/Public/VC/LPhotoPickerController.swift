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
        barView.delegate = self
        return barView
    }()
    
    fileprivate lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 1
        flowLayout.minimumInteritemSpacing = 1
        flowLayout.itemSize = CGSize(width: (Constant.screenWidth - 13)/4, height: (Constant.screenWidth - 13)/4)
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: Constant.navbarAndStatusBar, width: Constant.screenWidth, height: Constant.screenHeight - Constant.navbarAndStatusBar - Constant.bottomBarHeight), collectionViewLayout: flowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.white
        return collectionView
    }()
    
    fileprivate var dataArray = [LMediaResourcesModel]()
    
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
    
    fileprivate func checkSelectedModels() {
        guard let navVC = navigationController as? LImagePickerController else { return }
        tabBarView.maxCount = navVC.maxSelectCount
        tabBarView.currentCount = navVC.selectArray.count
        if navVC.selectArray.count == 0 { return }
        dataArray = dataArray.map {
            var model = $0
            model.isSelect = navVC.selectArray.contains(where: {$0 == model})
            return model
        }
    }
    
    fileprivate func didSelectCellButton(_ isSelect: Bool, indexPath: IndexPath) -> Bool {
        guard let navVC = navigationController as? LImagePickerController else { return false }
        if !isSelect {
            if navVC.selectArray.count < navVC.maxSelectCount {
                navVC.selectArray.append(dataArray[indexPath.item])
                dataArray[indexPath.item].isSelect = !isSelect
                tabBarView.currentCount = navVC.selectArray.count
                return true
            }else {
                view.getControllerFromView()?.showAlertWithTitle("最多只能选择\(navVC.maxSelectCount)张照片")
                return false
            }
        }else {
            navVC.selectArray.removeAll(where: { $0 == dataArray[indexPath.item] })
            dataArray[indexPath.item].isSelect = !isSelect
            tabBarView.currentCount = navVC.selectArray.count
            return true
        }
    }
}

extension LPhotoPickerController: PromptViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, ShowImageProtocol, ImageTabBarViewDelegate, UIViewControllerTransitioningDelegate {
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
            return self?.didSelectCellButton(select, indexPath: indexPath) == true
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        navView.allNumber = 1
        guard let cell = collectionView.cellForItem(at: indexPath) as? LImagePickerCell else { return }
        //            animationDelegate = nil
//        animationDelegate = ModelAnimationDelegate(originalView: cell.imageView)
        showImage(dataArray, currentIndex: indexPath.item, fromVC: self)
        
//        showImage(dataArray, currentIndex: indexPath.item)
    }
    
    func imageTabBarViewButton(_ buttonType: ImageTabBarButtonType) {
        guard let navVC = navigationController as? LImagePickerController else { return }
        if buttonType == .preview {
            let animationDelegate = ModelAnimationDelegate(superView: nil, currentIndex: 0)
            showImage(navVC.selectArray, currentIndex: 0, delegate: animationDelegate, fromVC: self)
        }else if buttonType == .complete {
            let option = PHImageRequestOptions()
            option.resizeMode = .fast
            let group = DispatchGroup()
            var imageArr = [UIImage]()
            var assetArr = [PHAsset]()
            for mediaModel in navVC.selectArray {
                if let asset = mediaModel.dataProtocol as? PHAsset {
                    group.enter()
                    PHImageManager.default().requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFill, options: option) { (image, info) in
                        if let image = image {
                            imageArr.append(image)
                            assetArr.append(asset)
                        }
                        group.leave()
                    }
                }
            }
            
            group.notify(queue: DispatchQueue.main) {
                print("1231232")
                print(imageArr)
                print(assetArr)
            }
            
        }
    }
}

extension LPhotoPickerController: ShowImageVCDelegate {
    
    func showImageDidSelect(_ viewController: ShowImageViewController, index: Int) -> Bool {
        guard let navVC = navigationController as? LImagePickerController else { return false}
        if dataArray.contains(where: { $0 == navVC.selectArray[index] }) {
            
        }
        return false
        
//        let indexPath = IndexPath(item: index, section: 0)
//        let isSelect: Bool = didSelectCellButton(dataArray[index].isSelect, indexPath: indexPath)
//        collectionView.reloadItems(at: [indexPath])
//        return isSelect
    }
    

    
    
}
