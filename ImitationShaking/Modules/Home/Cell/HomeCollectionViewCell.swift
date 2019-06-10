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
    
    public var listModel = HomeVideoListModel() {
        didSet {
            if let url = URL(string: listModel.visitPath) {
                let playerItem = AVPlayerItem(url: url)
                self.player.replaceCurrentItem(with: playerItem)
                player.play()
            }
            operationView.listModel = listModel
        }
    }
    
    
    // MARK:- layout
    fileprivate func layoutView() {
        
        self.player = AVPlayer()
        let videoLayer = AVPlayerLayer(player: player)
        videoLayer.videoGravity = .resizeAspect
        videoLayer.frame = contentView.bounds
        contentView.layer.addSublayer(videoLayer)
        
        NotificationCenter.default.addObserver(self, selector: #selector(moviePlayDidEnd(_ :)), name: Notification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapClick))
//        contentView.isUserInteractionEnabled = true
//        contentView.addGestureRecognizer(tap)
        
        contentView.addSubview(operationView)
        operationView.snp.makeConstraints { (make) in
            make.top.equalTo(Constant.navbarAndStatusBar)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(contentView.snp_bottom).offset(-Constant.bottomBarHeight)
        }
    }
    
    // MARK:- Event
    @objc fileprivate func tapClick() {
        if player.timeControlStatus == .paused {
            player.play()
        }else if player.timeControlStatus == .playing {
            player.pause()
        }

    }
    
    @objc fileprivate func moviePlayDidEnd(_ notification: Notification) {
        let item = notification.object as? AVPlayerItem
        item?.seek(to: CMTime.zero, completionHandler: nil)
        player.play()
    }
    
}
