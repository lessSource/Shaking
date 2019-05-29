//
//  HomeCollectionViewCell.swift
//  ImitationShaking
//
//  Created by Lj on 2019/5/26.
//  Copyright © 2019 study. All rights reserved.
//

import UIKit
import SnapKit
import AVFoundation

class HomeCollectionViewCell: UICollectionViewCell {
 
    var player: AVPlayer!
    
    fileprivate lazy var operationView: HomeVideoOperationView = {
        let view = HomeVideoOperationView()
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- layout
    fileprivate func layoutView() {
        let url = URL(string: "http://47.93.30.220/video/1/c73b0aa8-45c1-4e87-86c2-7d6d5c3fe4fc.mp4")
        if let videoUrl = url {
            let playerItem = AVPlayerItem(url: videoUrl)
            self.player = AVPlayer(playerItem: playerItem)

            let videoLayer = AVPlayerLayer(player: player)
            videoLayer.videoGravity = .resizeAspect
            videoLayer.frame = contentView.bounds
            contentView.layer.addSublayer(videoLayer)
            player.play()
        }
        
        contentView.addSubview(operationView)
        operationView.snp.makeConstraints { (make) in
            make.top.equalTo(Constant.navbarAndStatusBar)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(contentView.snp_bottom).offset(-Constant.bottomBarHeight)
        }
    }
    
}
