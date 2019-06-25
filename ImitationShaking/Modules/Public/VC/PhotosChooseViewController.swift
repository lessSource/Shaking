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
        collectionView.register(PhotosCollectionCell.self, forCellWithReuseIdentifier: PhotosCollectionCell.identifire)
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


extension PhotosChooseViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mediaType == .image ? imageDataArray.count : videoDataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: PhotosCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotosCollectionCell.identifire, for: indexPath) as! PhotosCollectionCell
        let imageManager: PHCachingImageManager = PHCachingImageManager()
        if mediaType == .image {
            let width = (Constant.screenWidth - 3)/4
            imageManager.requestImage(for: imageDataArray[indexPath.row], targetSize: CGSize(width: width, height: width), contentMode: .aspectFill, options: nil) { (image, dic) in
                cell.imageView.image = image
            }
        }else {
            cell.imageView.image = videoDataArray[indexPath.row].image
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}


class PhotosCollectionCell: UICollectionViewCell {
    
    fileprivate lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - layoutView
    fileprivate func layoutView() {
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.top.left.equalToSuperview()
        }
    }

}
