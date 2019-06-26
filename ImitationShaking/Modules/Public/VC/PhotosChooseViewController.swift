//
//  PhotosChooseViewController.swift
//  ImitationShaking
//
//  Created by Lj on 2019/6/20.
//  Copyright © 2019 study. All rights reserved.
//

import UIKit
import Photos

class PhotosChooseViewController: BaseViewController {
    
    public var mediaType: PHAssetMediaType = PHAssetMediaType.video
    fileprivate var delegate: ModelAnimationDelegate?

    fileprivate lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 1
        flowLayout.minimumInteritemSpacing = 1
        flowLayout.itemSize = CGSize(width: (Constant.screenWidth - 3)/4, height: (Constant.screenWidth - 3)/4)
        
        let collection = UICollectionView(frame: CGRect(x: 0, y: 0, width: Constant.screenWidth, height: view.height - 120 - Constant.statusHeight), collectionViewLayout: flowLayout)
        collection.backgroundColor = UIColor.white
        collection.delegate = self
        collection.dataSource = self
        return collection
    }()
    
    fileprivate var imageDataArray = [PHAsset]()
    fileprivate var videoDataArray = [ContestChooseVideo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black
        view.addSubview(collectionView)
        layoutView()
    }
    
    // MARK: - layoutView
    fileprivate func layoutView() {
        collectionView.register(PhotosChooseCollectionViewCell.self, forCellWithReuseIdentifier: PhotosChooseCollectionViewCell.identifire)
        PublicCameraStruct.getPhotoAlbumMedia(mediaType) { (data) in
            self.loadData(data)
        }
    }
    
    fileprivate func loadData(_ dataArray: [PHAsset]) {
        if mediaType == .image {
            imageDataArray = dataArray
            collectionView.reloadData()
        }else {
            PublicCameraStruct.getVideoCoverImageAndTime(dataArray) { (data) in
                self.videoDataArray = data
                self.collectionView.reloadData()
            }
        }
    }
}


extension PhotosChooseViewController: UICollectionViewDelegate, UICollectionViewDataSource, UIViewControllerTransitioningDelegate, ShowImageProtocol {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mediaType == .image ? imageDataArray.count : videoDataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: PhotosChooseCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotosChooseCollectionViewCell.identifire, for: indexPath) as! PhotosChooseCollectionViewCell
        let imageManager: PHCachingImageManager = PHCachingImageManager()
        let width = (Constant.screenWidth - 3)/4
        if mediaType == .image {
            imageManager.requestImage(for: imageDataArray[indexPath.row], targetSize: CGSize(width: width, height: width), contentMode: .aspectFill, options: nil) { (image, dic) in
                cell.imageView.image = image
            }
        }else {
            imageManager.requestImage(for: videoDataArray[indexPath.row].asset ?? PHAsset(), targetSize: CGSize(width: width, height: width), contentMode: .aspectFill, options: nil) { (image, dic) in
                cell.imageView.image = image
                cell.timeLabel.text = self.videoDataArray[indexPath.row].duration.formatting
            }
            
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if mediaType == .image {
            let imageManager: PHCachingImageManager = PHCachingImageManager()
            imageManager.requestImage(for: imageDataArray[indexPath.row], targetSize: CGSize(width: view.width, height: view.height), contentMode: .aspectFill, options: nil) { (image, dic) in
//                self.collection(collectionView, indexPath: indexPath, image: image)
                print("123")
            }
//            collection(collectionView, indexPath: indexPath, image: UIImage?)
            
            print("456")

            
            guard let cell = collectionView.cellForItem(at: indexPath) as? PhotosChooseCollectionViewCell else { return }
            delegate = nil
            delegate = ModelAnimationDelegate(originalView: cell.imageView)
            showImage(cell.imageView.image, currentIndex: 0, delegate: delegate)
        }
    }
    
    fileprivate func collection(_ collection: UICollectionView, indexPath: IndexPath, image: UIImage?) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? PhotosChooseCollectionViewCell else { return }
        delegate = nil
        delegate = ModelAnimationDelegate(originalView: cell.imageView)
        showImage(image, currentIndex: 0, delegate: delegate)
    }
}


