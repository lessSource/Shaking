//
//  HomeViewController.swift
//  ImitationShaking
//
//  Created by Lj on 2019/5/25.
//  Copyright © 2019 study. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import Moya
import Photos

class HomeViewController: BaseViewController {
    
    fileprivate lazy var hedaerView: HomeHeaderView = {
        let headerView = HomeHeaderView(frame: CGRect(x: 0, y: 0, width: Constant.screenWidth, height: Constant.navbarAndStatusBar))
        return headerView
    }()
    
    
    fileprivate lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: Constant.screenWidth, height: Constant.screenHeight)
        flowLayout.minimumLineSpacing = CGFloat.leastNormalMagnitude
        flowLayout.minimumInteritemSpacing = CGFloat.leastNormalMagnitude
        
        let collection = UICollectionView(frame: CGRect(x: 0, y: 0, width: Constant.screenWidth, height: Constant.screenHeight), collectionViewLayout: flowLayout)
        collection.delegate = self
        collection.dataSource = self
        collection.isPagingEnabled = true
        if #available(iOS 11.0, *) {
            collection.contentInsetAdjustmentBehavior = .never
        }        
        return collection
    }()
    
    fileprivate var dataArray = [HomeVideoListModel]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        collectionView.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: HomeCollectionViewCell.identifire)
//        view.addSubview(collectionView)
        
        view.addSubview(hedaerView)
        
        print(Date.timeAgoSinceDate("1551365260".timeStampDate))
        
        if let jsonPath = R.file.provincesDataJson(), let school = R.file.schoolDataJson() {
            do {
                let jsonData = try Data(contentsOf: jsonPath)
                
                let schoolData = try Data(contentsOf: school)

                
                let array = try JSON(data: jsonData)
                
                let array1 = try JSON(data: schoolData)

                
                print(array, array1)
                
            } catch {
                
            }
            
        }
        
        requestVideoList()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let photoVC = LImagePickerController(withMaxImage: 9, delegate: self)
        present(photoVC, animated: true, completion: nil)
        
//        let alertVC = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//                    let cancelAction = UIAlertAction(title: "取消", style: .default, handler: nil)
//                    alertVC.addAction(cancelAction)
//        //            alertVC.view.removeConstraint(alertVC.view.constraints[4])
//        //            alertVC.view.constraints
//        //            alertVC.view.removeConstraint(T##constraint: NSLayoutConstraint##NSLayoutConstraint)
//        //            alertVC.view.constraintsAffectingLayout(for: NSLayoutConstraint.Axis)
//        if let popver = alertVC.popoverPresentationController {
//            popver.sourceView = view
//            popver.sourceRect = view.bounds
//            popver.permittedArrowDirections = .any
//        }
        
//        present(alertVC, animated: true, completion: nil)
    }
    
    
    // MARK:- request
    fileprivate func requestVideoList() {
        Network.default.request(CommonTargetTypeApi.getRequest(VideoRequest.list, nil), successClosure: { (response) in
            if let array = [HomeVideoListModel].deserialize(from: response.arrayObject) as? [HomeVideoListModel] {
                self.dataArray = array
            }
            self.collectionView.reloadData()
        }) { (error) in
            print(error)
        }
    }
    
    
    // 测试头像
    fileprivate func requestHeadImage() {
//        var params: Dictionary = [String: Any]()
//        let image = UIImage(named: "icon_music")
//        let str: String = "意大利"
//        let data1 = str.data(using: String.Encoding.utf8)

        
        
//        if let jsonPath = R.file.provincesDataJson(), let school = R.file.schoolDataJson() {
//            do {
////                let jsonData = try Data(contentsOf: jsonPath)
//
////                let schoolData = try Data(contentsOf: school)
//
////                let ddd: String = String()
//
////                let dd: Int = Int()
//
////                let dddd: CGFloat = CGFloat()
//
////                let array = try JSON(data: jsonData)
//
////                let array1 = try JSON(data: schoolData)
//                let image = R.image.icon_music()?.pngData() ?? Data()
//
//                let data =  Moya.MultipartFormData(provider: .data(image), name: "headImg", fileName: "headImg", mimeType: "png")
//
//                Network.default.request(CommonTargetTypeApi.uploadMultipart(LoginRegisterRequest.headImage, [data], nil), successClosure: { (response) in
//                    print("ddd")
//                }) { (error) in
//                    print("aaaaa")
//                }
//
////                print(array, array1)
//
//            } catch {
//
//            }
        
        }
        
        
        
//        let date = MultipartFormData()
//        date.append(image, withName: "headImg")
//        let Provider = MultipartFormData.FormDataProvider()
        

        
//        let dd = RequestMultipartFormData()
//        dd.append(image, withName: "headImg", fileName: "headImg", mimeType: "headImg")
        
//        params.updateValue(image ?? Date(), forKey: "headImg")
//        Network.default.request(CommonTargetTypeApi.uploadMultipart(RequestHeadImage, [data]), successClosure: { (response) in
//            print("ddd")
//        }) { (error) in
//
//        }
//    }
}

extension HomeViewController: LImagePickerDelegate {
    func imagePickerController(_ picker: LImagePickerController, photos: [UIImage], assers: [PHAsset]) {
        print(photos, assers)
    }
}


extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: HomeCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.identifire, for: indexPath) as! HomeCollectionViewCell
        cell.backgroundColor = .black
        cell.listModel = dataArray[indexPath.item]
        cell.handLeftClick = { [weak self] in
            self?.pushNextVC()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let videoCell: HomeCollectionViewCell = cell as! HomeCollectionViewCell
//        videoCell.player.r
        videoCell.player.pause()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if se
        
//        let rectInTableView = collectionView.convert(T##rect: CGRect##CGRect, to: <#T##UIView?#>)
    }
    
    func pushNextVC() {
        let mineVC = MineViewController()
        mineVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(mineVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let loginVC = LoginViewController()
        //            loginVC.modalPresentationStyle = .overCurrentContext
        //            self.definesPresentationContext = true
//        loginVC.modalPresentationStyle = .overCurrentContext
//        loginVC.view.backgroundColor = UIColor(white: 0, alpha: 0.2)
//        self.definesPresentationContext = true
//        loginVC.modalPresentationStyle = .overCurrentContext
//        present(loginVC, animated: true, completion: nil)
    }
}

