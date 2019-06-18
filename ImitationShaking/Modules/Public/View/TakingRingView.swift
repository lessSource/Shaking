//
//  TakingRingView.swift
//  ImitationShaking
//
//  Created by less on 2019/6/18.
//  Copyright © 2019 study. All rights reserved.
//

import UIKit

class TakingRingView: UIView {

    fileprivate var cuontDurTime: Timer?
    fileprivate var COUNT_DUR_TIMER_INTERVAL: TimeInterval = 0.05
    
    fileprivate var currentDuration: CGFloat = 5
    fileprivate var current: CGFloat = 0.5

    fileprivate var isStyle: Bool = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var lineWidth: CGFloat = 0 {
        didSet {
            startCountDurTimer()
        }
    }
    
    override func draw(_ rect: CGRect) {
        guard let context: CGContext = UIGraphicsGetCurrentContext() else {
            return
        }
        context.setLineWidth(currentDuration)
        context.setStrokeColor(UIColor.withHex(hexString: "#E7445A", alpha: 0.8).cgColor)
        context.addArc(center: CGPoint(x: width/2, y: height/2), radius: height/2 - currentDuration/2, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        context.strokePath()
    }
    
    fileprivate func startCountDurTimer() {
        cuontDurTime = Timer(timeInterval: COUNT_DUR_TIMER_INTERVAL, repeats: true, block: { [weak self] (timer) in
            self?.timeTask(time: timer)
        })
        RunLoop.current.add(cuontDurTime!, forMode: .common)
    }
    
    fileprivate func timeTask(time: Timer) {
//        if currentDuration >= lineWidth {
//            stopCountDurTimer()
//        }else {
//            isStyle ? (currentDuration += 1) : (currentDuration -= 1)
//            if currentDuration >= 20 {
//                isStyle = false
//            }
//            if currentDuration <= 5 {
//                isStyle = true
//            }
//            setNeedsDisplay()
//        }
        
        isStyle ? (currentDuration += current) : (currentDuration -= current)
        if currentDuration >= lineWidth {
            current = 0.1
            lineWidth = 10
            COUNT_DUR_TIMER_INTERVAL = 1
            isStyle = false
            stopCountDurTimer()
            startCountDurTimer()
        }
        if currentDuration <= 5 {
            isStyle = true
        }
        setNeedsDisplay()
    }
    
    fileprivate func stopCountDurTimer() {
        if self.cuontDurTime != nil {
            self.cuontDurTime?.invalidate()
            self.cuontDurTime = nil
        }
    }
}
