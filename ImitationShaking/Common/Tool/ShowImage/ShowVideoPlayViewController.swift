//
//  ShowVideoPlayViewController.swift
//  ImitationShaking
//
//  Created by less on 2019/8/28.
//  Copyright © 2019 study. All rights reserved.
//

import UIKit
import AVFoundation

class ShowVideoPlayViewController: UIViewController {

    public var currentImage: UIImage?
    
    public var asset: AVAsset?
    
    fileprivate var player: AVPlayer?
    
    fileprivate lazy var plyerLayer: AVPlayerLayer = {
        let plyerLayer = AVPlayerLayer()
        plyerLayer.videoGravity = .resizeAspect
        plyerLayer.frame = self.view.bounds
        return plyerLayer
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.red
        // Do any additional setup after loading the view
        self.view.layer.addSublayer(plyerLayer)
        guard let avAsset = self.asset else { return }
        
        let playerItem: AVPlayerItem = AVPlayerItem(asset: avAsset)
        
        player = AVPlayer(playerItem: playerItem)
        
        player?.play()
    }

}
