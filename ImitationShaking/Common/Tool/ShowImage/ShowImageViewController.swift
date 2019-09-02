//
//  ShowImageViewController.swift
//  ImitationShaking
//
//  Created by Lj on 2019/6/25.
//  Copyright © 2019 study. All rights reserved.
//


import UIKit
import Photos

protocol ShowImageVCDelegate: NSObjectProtocol {
    
    func showImageDidDelete(_ viewController: ShowImageViewController, index: Int)
    
    func showImageDidSelect(_ viewController: ShowImageViewController, index: Int) -> Bool
    
    func showImageDidSelect(_ viewContriller: ShowImageViewController, data: LMediaResourcesModel, index: Int) -> Bool
    
}

extension ShowImageVCDelegate {
    func showImageDidDelete(_ viewController: ShowImageViewController, index: Int) { }
    
    func showImageDidSelect(_ viewController: ShowImageViewController, index: Int) -> Bool {
        return false
    }
    
    func showImageDidSelect(_ viewContriller: ShowImageViewController, data: LMediaResourcesModel, index: Int) -> Bool {
        return false
    }

}


private let cellMargin: CGFloat = 20

class ShowImageViewController: UICollectionViewController {
        
    public weak var delegate: ShowImageVCDelegate?
    
    /** current index  */
    fileprivate var currentIndex: Int = 0 {
        didSet {
            navView.titleLabel.text = "\(currentIndex + 1)/\(dataArray.count)"
        }
    }
    /** 数据 */
    fileprivate var dataArray: Array = [LMediaResourcesModel]()
    /** 是否显示导航栏 */
    fileprivate var isNavHidden: Bool = false
    
    fileprivate lazy var navView: ShowImageNavView = {
        let navView = ShowImageNavView(frame: CGRect(x: 0, y: -Constant.navbarAndStatusBar, width: Constant.screenWidth, height: Constant.navbarAndStatusBar))
        return navView
    }()
    
    fileprivate lazy var tabBarView: ShowImageTabBarView = {
        let barView: ShowImageTabBarView = ShowImageTabBarView(frame: CGRect(x: 0, y: Constant.screenHeight, width: Constant.screenWidth, height: Constant.bottomBarHeight))
        return barView
    }()
    
    
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(dataArray: [LMediaResourcesModel], currentIndex: Int) {
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
        navView.titleLabel.text = "\(currentIndex + 1)/\(dataArray.count)"
        navView.didSelectButtonClosure = { [weak self] select in
            guard let `self` = self else { return false }
            if self.delegate?.showImageDidSelect(self, index: self.currentIndex) == true {
                self.dataArray[self.currentIndex].isSelect = !self.dataArray[self.currentIndex].isSelect
                return true
            }
            return false
        }
    }

    fileprivate func layoutView() {
        collectionView?.frame = UIScreen.main.bounds
        collectionView?.width = Constant.screenWidth + cellMargin
        collectionView?.alwaysBounceHorizontal = true
        collectionView?.isPagingEnabled = true
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.register(ShowImageCollectionViewCell.self, forCellWithReuseIdentifier: ShowImageCollectionViewCell.identifire)
        collectionView.scrollToItem(at: IndexPath(item: 0, section: currentIndex), at: .left, animated: false)
    }
    
    fileprivate func imageClick(_ cell: ShowImageCollectionViewCell, cellForItemAt indexPath: IndexPath, type: ShowImageCollectionViewCell.ActionEnum) {
        switch type {
        case .tap:
            UIView.animate(withDuration: 0.15, animations: {
                self.tabBarView.y = self.isNavHidden ? Constant.screenHeight : Constant.screenHeight - self.tabBarView.height
                self.navView.y = self.isNavHidden ? -Constant.navbarAndStatusBar : 0
            }) { finish in
                if finish { self.isNavHidden = !self.isNavHidden }
            }
        case .long: break
        case .play:
            let showVideoPlayVC = ShowVideoPlayViewController()
            showVideoPlayVC.videoModel = dataArray[indexPath.section]
            showVideoPlayVC.currentImage = cell.currentImage.image
            present(showVideoPlayVC, animated: false, completion: nil)
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
        cell.updateImage(imageData: dataArray[indexPath.section])
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
        navView.isImageSelect = dataArray[currentIndex].isSelect
    }
    
}


class ShowImageTabBarView: UIView {
    
    public var maxCount: Int = 1
    
    public var currentCount: Int = 0 {
        didSet {
            if currentCount == 0 {
                completeButton.setTitle("完成", for: .normal)
                completeButton.isUserInteractionEnabled = false
                completeButton.setTitleColor(UIColor(white: 1.0, alpha: 0.5), for: .normal)
            }else {
                completeButton.setTitle("完成(\(currentCount)/\(maxCount))", for: .normal)
                completeButton.isUserInteractionEnabled = true
                completeButton.setTitleColor(UIColor(white: 1.0, alpha: 1.0), for: .normal)
            }
            completeButton.width = completeButton.titleLabel?.intrinsicContentSize.width ?? 0
            completeButton.x = Constant.screenWidth - 15 - completeButton.width
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        layoutView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate lazy var completeButton: UIButton = {
        let button = UIButton(frame: CGRect(x: Constant.screenWidth - 55, y: 4.5, width: 40, height: 40))
        button.setTitle("完成", for: .normal)
        button.setTitleColor(UIColor(white: 1.0, alpha: 0.5), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        return button
    }()
    
    // MARK:- layoutView
    fileprivate func layoutView() {
        addSubview(completeButton)
    }
}


class ShowImageNavView: UIView {
    
    typealias SelectClosure = (Bool) -> (Bool)
    
    public var didSelectButtonClosure: SelectClosure?
    
    public var isImageSelect: Bool = false {
        didSet {
            selectImageView.image = !isImageSelect ? R.image.icon_album_nor() : R.image.icon_album_sel()
            selectButton.isSelected = isImageSelect
        }
    }
    
    fileprivate lazy var backButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 10, y: Constant.statusHeight, width: 44, height: 44))
        button.setImage(R.image.icon_nav_back(), for: .normal)
        return button
    }()
    
    fileprivate lazy var selectImageView: UIImageView = {
        let image = UIImageView(frame: CGRect(x: Constant.screenWidth - 34, y: Constant.statusHeight + 10, width: 24, height: 24))
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.image = R.image.icon_album_nor()
        return image
    }()
    
    public lazy var selectButton: UIButton = {
        let button = UIButton(frame: CGRect(x: Constant.screenWidth - 44, y: Constant.statusHeight, width: 44, height: 44))
        return button
    }()
    
    public lazy var titleLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 100, y: Constant.statusHeight, width: Constant.screenWidth - 200, height: 44))
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .center
        return label
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
        addSubview(selectImageView)
        addSubview(selectButton)
        addSubview(titleLabel)
        backButton.addTarget(self, action: #selector(backButtonClick), for: .touchUpInside)
        selectButton.addTarget(self, action: #selector(selectButtonClick(_ :)), for: .touchUpInside)
    }
    
    // MARK:- Event
    @objc fileprivate func backButtonClick() {
        getControllerFromView()?.dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func selectButtonClick(_ sender: UIButton) {
        guard let closure = didSelectButtonClosure else { return }
        if closure(sender.isSelected) {
            selectImageView.image = sender.isSelected ? R.image.icon_album_nor() : R.image.icon_album_sel()
            sender.isSelected = !sender.isSelected
            if sender.isSelected {
                selectImageView.showOscillatoryAnimation()
            }
        }
    }
    
}

