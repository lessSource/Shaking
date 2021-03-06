//
//  LAlbumPickerController.swift
//  ImitationShaking
//
//  Created by Lj on 2019/8/26.
//  Copyright © 2019 study. All rights reserved.
//

import UIKit
import Photos

class LAlbumPickerController: UIViewController {
    
    fileprivate lazy var navView: LImageNavView = {
        let navView = LImageNavView(frame: CGRect(x: 0, y: 0, width: Constant.screenWidth, height: Constant.navbarAndStatusBar))
        navView.backButton.isHidden = true
        navView.titleLabel.text = "全部图片"
        navView.backgroundColor = UIColor.white
        return navView
    }()
    
    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: Constant.navbarAndStatusBar, width: Constant.screenWidth, height: Constant.screenHeight - Constant.navbarAndStatusBar), style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 80
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.separatorStyle = .none
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        return tableView
    }()
    
    fileprivate lazy var dataArray: Array = [LAlbumPickerModel]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        LImagePickerManager.shared.getAlbumResources { array in
            self.dataArray = array
            self.loadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        view.addSubview(navView)
        view.addSubview(tableView)
        tableView.register(LAlbumPickerTableViewCell.self, forCellReuseIdentifier: LAlbumPickerTableViewCell.identifire)
    }
    
    fileprivate func loadData() {
        guard let navVC = navigationController as? LImagePickerController else {
            tableView.reloadData()
            return
        }
        for i in 0..<dataArray.count {
            var selectCount: Int = 0
            for mediaModel in navVC.selectArray {
                if dataArray[i].fetchResult?.contains(mediaModel.dataProtocol as? PHAsset ?? PHAsset()) == true {
                    selectCount += 1
                }
            }
            dataArray[i].selectCount = selectCount
        }
        tableView.reloadData()
    }
}

extension LAlbumPickerController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: LAlbumPickerTableViewCell = tableView.dequeueReusableCell(withIdentifier: LAlbumPickerTableViewCell.identifire) as! LAlbumPickerTableViewCell
        cell.albumModel = dataArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let photoPickerVC = LPhotoPickerController()
        photoPickerVC.pickerModel = dataArray[indexPath.row]
        pushAndHideTabbar(photoPickerVC)
    }
    
}
