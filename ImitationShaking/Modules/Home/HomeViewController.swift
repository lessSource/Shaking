//
//  HomeViewController.swift
//  ImitationShaking
//
//  Created by Lj on 2019/5/25.
//  Copyright © 2019 study. All rights reserved.
//

import UIKit
import SwiftyJSON

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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        collectionView.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: "HomeCollectionViewCell")
        view.addSubview(collectionView)
        
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
        
    }
    
    
}


extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: HomeCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as! HomeCollectionViewCell
        cell.backgroundColor = .black
        cell.url = ""
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let videoCell: HomeCollectionViewCell = cell as! HomeCollectionViewCell
//        videoCell.player.r
        videoCell.player.pause()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if se
        
//        let rectInTableView = collectionView.convert(<#T##rect: CGRect##CGRect#>, to: <#T##UIView?#>)
    }
}
