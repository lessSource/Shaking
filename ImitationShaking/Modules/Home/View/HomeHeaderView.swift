//
//  HomeHeaderView.swift
//  ImitationShaking
//
//  Created by Lj on 2019/5/26.
//  Copyright © 2019 study. All rights reserved.
//

import UIKit

class HomeHeaderView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(white: 1, alpha: 0.0)
        layoutView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- layout
    fileprivate func layoutView() {
        let patButton = UIButton()
        patButton.setTitle("随拍", for: .normal)
        patButton.setImage(R.image.icon_camera(), for: .normal)
        patButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        patButton.titleEdgeInsets = UIEdgeInsets(top: 2, left: 5, bottom: 0, right: 0)
        patButton.setTitleColor(UIColor.textColor_999999, for: .normal)
        patButton.addTarget(self, action: #selector(patButtonClick), for: .touchUpInside)
        self.addSubview(patButton)
        patButton.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalTo(Constant.statusHeight + 20)
            make.width.equalTo(60)
        }
        
        let searchButton = UIButton()
        searchButton.setImage(R.image.icon_search(), for: .normal)
        searchButton.addTarget(self, action: #selector(searchButtonClick), for: .touchUpInside)
        self.addSubview(searchButton)
        searchButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-15)
            make.centerY.equalTo(patButton)
        }
        
        let segment = UISegmentedControl(items: ["推荐","上海"])
        segment.selectedSegmentIndex = 0
        segment.tintColor = .white
        segment.addTarget(self, action: #selector(segmentClick(_ :)), for: .valueChanged)
        self.addSubview(segment)
        segment.snp.makeConstraints { (make) in
            make.centerY.equalTo(patButton)
            make.centerX.equalToSuperview()
        }

    }
}

// MARK:- Event
extension HomeHeaderView {
    // 随拍
    @objc fileprivate func patButtonClick() {
        print("随拍")
    }
    
    // 搜索
    @objc fileprivate func searchButtonClick() {
        print("搜索")
    }
    
    // 标签切换
    @objc fileprivate func segmentClick(_ segment: UISegmentedControl) {
        if segment.selectedSegmentIndex == 0 {
            print("推荐")
        }else {
            print("上海")
        }
    }
}
