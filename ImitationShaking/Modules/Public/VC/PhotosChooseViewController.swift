//
//  PhotosChooseViewController.swift
//  ImitationShaking
//
//  Created by Lj on 2019/6/20.
//  Copyright © 2019 study. All rights reserved.
//

import UIKit
import Photos
import VTMagic

class PhotosChooseViewController: BaseViewController {
    
    fileprivate lazy var magicVC: VTMagicController = {
        let magic = VTMagicController()
        magic.magicView.navigationColor = UIColor.white
        magic.magicView.layoutStyle = .divide
        magic.magicView.switchStyle = .default
        magic.magicView.navigationHeight = 40
//        magic.magicView.dataSource = self
//        magic.magicView.delegate = self
        return magic
    }()
    
    fileprivate lazy var contentView: UIView = {
        let contentView = UIView(frame: CGRect(x: 0, y: Constant.statusHeight, width: Constant.screenWidth, height: Constant.screenHeight - Constant.statusHeight))
        contentView.backgroundColor = UIColor.white
        contentView.corner(byRoundingCorners: [.topLeft, .topRight], radii: 10)
        return contentView
    }()
    
    fileprivate lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 1
        flowLayout.minimumInteritemSpacing = 1
        flowLayout.itemSize = CGSize(width: (Constant.screenWidth - 3)/4, height: (Constant.screenWidth - 3)/4)
        
        let collection = UICollectionView(frame: CGRect(x: 0, y: 80, width: contentView.width, height: contentView.height - 80), collectionViewLayout: flowLayout)
        collection.delegate = self
        collection.dataSource = self
        return collection
    }()
    
    fileprivate var dataArray = [PHAsset]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black
        view.addSubview(contentView)
        contentView.addSubview(collectionView)
        layoutView()
    }
    
    // MARK: - layoutView
    fileprivate func layoutView() {
        collectionView.register(PhotosCollectionCell.self, forCellWithReuseIdentifier: PhotosCollectionCell.identifire)
        
        PublicCameraStruct.getPhotoAlbumMedia(.image) { (data) in
            self.dataArray = data
            self.collectionView.reloadData()
        }
    }
}

//extension PhotosChooseViewController: VTMagicViewDelegate, VTMagicViewDataSource {
//    func menuTitles(for magicView: VTMagicView) -> [String] {
//        return ["视频", "图片"]
//    }
//
//    func magicView(_ magicView: VTMagicView, menuItemAt itemIndex: UInt) -> UIButton {
//        let button: UIButton? = magicView.dequeueReusableItem(withIdentifier: "dddd")
//        return button!
//    }
//
//    func magicView(_ magicView: VTMagicView, viewControllerAtPage pageIndex: UInt) -> UIViewController {
//
//    }
    
    
//}


extension PhotosChooseViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: PhotosCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotosCollectionCell.identifire, for: indexPath) as! PhotosCollectionCell
        let imageManager: PHCachingImageManager = PHCachingImageManager()
        let width = (Constant.screenWidth - 3)/4
        imageManager.requestImage(for: dataArray[indexPath.row], targetSize: CGSize(width: width, height: width), contentMode: .aspectFill, options: nil) { (image, dic) in
            cell.imageView.image = image
            print(Thread.current)

        }
        imageManager.requestPlayerItem(forVideo: dataArray[indexPath.row], options: nil) { (player, dic) in
            
//            cell.imageView.image = R.image.icon_fork()
//            print(Thread.current)
//            ContestChooseVideo.Video
            
//            UIImage.t
            
            DispatchQueue.main.async {
                print(CMTimeGetSeconds(player?.asset.duration ?? CMTime.zero))
                print(Thread.current)
            }
            
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        dismiss(animated: true, completion: nil)
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
