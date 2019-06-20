//
//  PhotosChooseViewController.swift
//  ImitationShaking
//
//  Created by Lj on 2019/6/20.
//  Copyright © 2019 study. All rights reserved.
//

import UIKit

class PhotosChooseViewController: BaseViewController {
    
    fileprivate var oldTranslation: CGPoint = CGPoint.zero
    fileprivate var isNeedDismiss: Bool = false
    // 手势中
    fileprivate var isInteraction: Bool = true
    // 完成动画
    fileprivate var shouldComplete: Bool = false

    fileprivate lazy var contentView: UIView = {
        let contentView = UIView(frame: CGRect(x: 0, y: Constant.statusHeight, width: Constant.screenWidth, height: Constant.screenHeight - Constant.statusHeight))
        contentView.backgroundColor = UIColor.white
        contentView.corner(byRoundingCorners: [.topLeft, .topRight], radii: 10)
        return contentView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black
        view.addSubview(contentView)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureClick(_ :)))
        view.addGestureRecognizer(panGesture)
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        dismiss(animated: true, completion: nil)
//    }
    
    @objc fileprivate func panGestureClick(_ gesture: UIPanGestureRecognizer) {
        // 获取手势触控的点作用在view的相对位置
        let translation = gesture.translation(in: gesture.view)
        // 每次手势触发的时候，重置
        isNeedDismiss = false
        switch gesture.state {
        case .began:
            // 交互动画判断
            isInteraction = true
            dismiss(animated: true, completion: nil)
        case .changed:
            // 当前触控点的赋值
            oldTranslation = translation
            // 触控点的转化
            var fraction = translation.y / Constant.screenHeight
            // 保证范围
            fraction = CGFloat(fmin(fmaxf(Float(fraction), 0.0), 1.0))
            // 滑动中的判断，
            shouldComplete = fraction > 0.382
            // 跟新进度
//            updatein
        case .ended:
            let speed = gesture.velocity(in: gesture.view)
            if speed.y >= 920 {
                isNeedDismiss = true
                shouldComplete = true
            }
            isInteraction = false
            
            
        default: break
            
        }
    }

}


class PresentVCAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    // 设置动画时长
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // 前一个ViewController动画的发起者
        let fromVC = transitionContext.viewController(forKey: .from)
        // 后一个ViewController动画的结束者
        guard let toVC = transitionContext.viewController(forKey: .to) else { return }
        // 转场动画的最终的frame
        let finalFrameForVC = transitionContext.finalFrame(for: toVC)
        // 装换的容器view,存放转场动画的容器
        let containerView = transitionContext.containerView
        // 没有涉及VC的view放大或者缩小，即可看做屏幕的尺寸
        let bounds = UIScreen.main.bounds
        // 后一个ViewController的frame
        toVC.view.frame = finalFrameForVC.offsetBy(dx: 0, dy: bounds.size.height)
        containerView.addSubview(toVC.view)
        
        // 改变前一个ViewController和后一个ViewController的动画
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            fromVC?.view.alpha = 0.5
            toVC.view.frame = finalFrameForVC
        }) { (finish) in
            transitionContext.completeTransition(true)
            fromVC?.view.alpha = 1
        }
    }
    
}

class DismissVCAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
        
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // 前一个ViewController动画的发起者
        guard let fromVC = transitionContext.viewController(forKey: .from) else { return }
        // 后一个ViewController动画的结束者
        guard let toVC = transitionContext.viewController(forKey: .to) else { return }
        
        let screenBounds = UIScreen.main.bounds
        // 获取前一个页面的frame
        let initFrame = transitionContext.initialFrame(for: fromVC)
        // 转场动画的toView的最终的frame
        let finalFrame = initFrame.offsetBy(dx: 0, dy: screenBounds.height)
        // 装换的容器view,存放转场动画的容器
        let containerView = transitionContext.containerView
        // 为了让转场动画衔接的更和谐
        let bgView = UIView(frame: fromVC.view.bounds)
        bgView.backgroundColor = UIColor.black
        toVC.view.addSubview(bgView)
        
        containerView.addSubview(toVC.view)
        containerView.sendSubviewToBack(toVC.view)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            fromVC.view.frame = finalFrame
            bgView.alpha = 0
        }) { (finish) in
            bgView.removeFromSuperview()
            let complate = transitionContext.transitionWasCancelled
            transitionContext.completeTransition(!complate)
        }
    }
}


