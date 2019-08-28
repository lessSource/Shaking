//
//  ShowImageViewController.swift
//  ImitationShaking
//
//  Created by Lj on 2019/6/25.
//  Copyright © 2019 study. All rights reserved.
//


import UIKit
import Photos

protocol ImageDataProtocol { }

extension UIImage: ImageDataProtocol { }

extension String: ImageDataProtocol { }

extension PHAsset: ImageDataProtocol { }

extension LAssetModel: ImageDataProtocol { }

private let cellMargin: CGFloat = 20

class ShowImageViewController: UICollectionViewController {
    
    fileprivate var imageArray: UIImage?
    
    /**  */
    fileprivate var currentIndex: Int = 0
    /** 数据 */
    fileprivate var dataArray: Array = [ImageDataProtocol]()
    /** 是否显示导航栏 */
    fileprivate var isNavHidden: Bool = false
    
    fileprivate lazy var navView: ShowImageNavView = {
        let navView = ShowImageNavView(frame: CGRect(x: 0, y: -Constant.navbarAndStatusBar, width: Constant.screenWidth, height: Constant.navbarAndStatusBar))
        return navView
    }()
    
    
    
    fileprivate lazy var tabBarView: ShowImageTabBarView = {
        let barView: ShowImageTabBarView = ShowImageTabBarView(frame: CGRect(x: 0, y: Constant.screenHeight, width: Constant.screenHeight, height: Constant.bottomBarHeight))
        return barView
    }()
    
    
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(imageArray: UIImage?, currentIndex: Int) {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: Constant.screenWidth + cellMargin, height: Constant.screenHeight)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        self.init(collectionViewLayout: layout)
        self.imageArray = imageArray
        self.currentIndex = currentIndex
    }
    
    convenience init(dataArray: [ImageDataProtocol], currentIndex: Int) {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: Constant.screenWidth + cellMargin, height: Constant.screenHeight)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        self.init(collectionViewLayout: layout)
        self.dataArray = dataArray
        self.currentIndex = currentIndex
    }
    
    deinit {
        print(self, "+++++释放")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutView()
        view.addSubview(tabBarView)
        view.addSubview(navView)
    }

    fileprivate func layoutView() {
        collectionView?.frame = UIScreen.main.bounds
        collectionView?.width = Constant.screenWidth + cellMargin
        collectionView?.alwaysBounceHorizontal = true
        collectionView?.isPagingEnabled = true
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.register(ShowImageCollectionViewCell.self, forCellWithReuseIdentifier: ShowImageCollectionViewCell.identifire)
        assert(dataArray.count != 0, "数据不能为空！！！！！")
        if dataArray.count > 0 {
            collectionView?.scrollToItem(at: IndexPath(item: 0, section: currentIndex > dataArray.count - 1 ? 0 : currentIndex), at: .left, animated: false)
        }
    }
    
    fileprivate func imageClick(_ cell: ShowImageCollectionViewCell, cellForItemAt indexPath: IndexPath, type: ShowImageCollectionViewCell.ActionEnum) {
        switch type {
        case .tap:
//            UIView.animate(withDuration: 0.15, animations: {
//                self.tabBarView.y = self.isNavHidden ? Constant.screenHeight : Constant.screenHeight - self.tabBarView.height
//                self.navView.y = self.isNavHidden ? -Constant.navbarAndStatusBar : 0
//            }) { finish in
//                if finish { self.isNavHidden = !self.isNavHidden }
//            }
            if let model = dataArray[indexPath.section] as? LAssetModel, model.asset.mediaType == .video {
                let showVideoPlayVC = ShowVideoPlayViewController()
                showVideoPlayVC.asset = model.asset
                showVideoPlayVC.currentImage = cell.currentImage.image
                present(showVideoPlayVC, animated: false, completion: nil)
            }
        case .long: break
        }
    }
}

// MARK: UICollectionViewDataSource
extension ShowImageViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataArray.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShowImageCollectionViewCell.identifire, for: indexPath) as! ShowImageCollectionViewCell
        cell.updateImage(imageProtocol: dataArray[indexPath.section])
        cell.imageClick(action: { [weak self] (type) in
            self?.imageClick(cell, cellForItemAt: indexPath, type: type)
        })
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let showImageCell = cell as! ShowImageCollectionViewCell
        showImageCell.scrollView.zoomScale = 1.0
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.item)
    }
    
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        currentIndex = Int(scrollView.contentOffset.x / scrollView.width)
        
        print("/////////\(currentIndex)/////////")
    }
    
}


class ShowImageTabBarView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        layoutView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- layoutView
    fileprivate func layoutView() {
        
    }
}


class ShowImageNavView: UIView {
    
    fileprivate lazy var backButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 10, y: Constant.statusHeight, width: 44, height: 44))
        button.setImage(R.image.icon_nav_back(), for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        layoutView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- layoutView
    fileprivate func layoutView() {
        addSubview(backButton)
        backButton.addTarget(self, action: #selector(backButtonClick), for: .touchUpInside)
    }
    
    // MARK:- Event
    @objc fileprivate func backButtonClick() {
        getControllerFromView()?.dismiss(animated: true, completion: nil)
    }
}

