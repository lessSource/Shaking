//
//  ShowImage.swift
//  ImitationShaking
//
//  Created by Lj on 2019/6/25.
//  Copyright © 2019 study. All rights reserved.
//

import Foundation

protocol ShowImageProtocol { }

extension ShowImageProtocol where Self: UIViewController, Self: UIViewControllerTransitioningDelegate {
    // 带动画的显示大图 ---- 必须遵循UIViewControllerTransitioningDelegate
    func showImage(_ dataArray: [ImageDataProtocol], currentIndex: Int, delegate: ModelAnimationDelegate?) {
        let showImageVC = ShowImageViewController(dataArray: dataArray, currentIndex: currentIndex)
        showImageVC.transitioningDelegate = delegate
        showImageVC.modalPresentationStyle = .custom
        present(showImageVC, animated: true, completion: nil)
    }
}

class ModelAnimationDelegate: NSObject, UIViewControllerTransitioningDelegate {
    fileprivate var isPresentAnimatotion: Bool = true
    fileprivate var isSuperView: Bool = false
    
    fileprivate var originalView1: UIImageView?
    fileprivate let animatTime: TimeInterval = 0.3
    
    
    fileprivate var superView: UIView?
    fileprivate var currentIndex: Int = 0
    
    init(originalView: UIImageView) {
        self.originalView1 = originalView
        super.init()
    }
    
    init(superView: UIView?, currentIndex: Int) {
        self.superView = superView
        self.currentIndex = currentIndex
        super.init()
    }
    
    deinit {
        print(self, "++++++释放")
    }
    
}

extension ModelAnimationDelegate: UIViewControllerAnimatedTransitioning {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresentAnimatotion = true
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresentAnimatotion = false
        return self
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animatTime
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        isPresentAnimatotion ? presentViewAnimation(transitionContext: transitionContext) : dismissViewAnimation(transitionContext: transitionContext)
    }
}

extension ModelAnimationDelegate {
    // 显示动画
    fileprivate func presentViewAnimation(transitionContext: UIViewControllerContextTransitioning) {
        presentViewDefaultAnimation(transitionContext: transitionContext)
//        guard let originalView = originalView1 else {
//            return
//        }
//
//        guard let image = originalView.image else {
//            fatalError("there is no image at selectedImageView")
//        }
//
//        // 过渡View
//        guard let toView = transitionContext.view(forKey: .to) else {
//            return
//        }
//        let toBackView = UIView(frame: toView.bounds)
//        toBackView.backgroundColor = UIColor.black
//        toView.addSubview(toBackView)
//        // 容器View
//        let containerView = transitionContext.containerView
//        // 过渡view添加到容器上
//        toView.alpha = 0
//        containerView.addSubview(toView)
//        // 新建一个imageView添加到目标view之上，做为动画view
//        let animateView = UIImageView()
//        animateView.image = image
//        animateView.contentMode = .scaleAspectFill
//        animateView.clipsToBounds = true
//        // 被选中的imageView到目标view上的坐标转换
//        guard let window = UIApplication.shared.delegate?.window else {
//            return
//        }
//        let originalFrame = originalView.convert(originalView.bounds, to: window)
//        animateView.frame = originalFrame
//        containerView.addSubview(animateView)
//
//        // endFrame
//        var endFrame: CGRect = .zero
//        let imageHeight = image.size.height / image.size.width * Constant.screenWidth
//        if imageHeight > Constant.screenHeight {
//            endFrame.size.height = Constant.screenHeight
//            endFrame.size.width = image.size.width / image.size.height * Constant.screenHeight
//            endFrame.origin.y = 0
//            endFrame.origin.x = Constant.screenWidth/2 - endFrame.width/2
//        }else {
//            endFrame.size.width = Constant.screenWidth
//            endFrame.size.height = image.size.height * endFrame.width / image.size.width
//            endFrame.origin.x = 0
//            endFrame.origin.y = Constant.screenHeight/2 - endFrame.height/2
//        }
//        toView.transform = CGAffineTransform(translationX: 0, y: toView.height)

//        // 过渡动画
//        UIView.animate(withDuration: animatTime, animations: {
//            toView.alpha = 1
//            toView.transform = CGAffineTransform(translationX: 0, y: 0)

//            animateView.frame = endFrame
//        }) { _ in
//            transitionContext.completeTransition(true)
//            animateView.removeFromSuperview()
//            toBackView.removeFromSuperview()
//        }
    }
    
    // 默认显示动画
    fileprivate func presentViewDefaultAnimation(transitionContext: UIViewControllerContextTransitioning) {
        guard let toView = transitionContext.view(forKey: .to) else {
            return
        }
        let containerView = transitionContext.containerView
        containerView.addSubview(toView)
        toView.transform = CGAffineTransform(translationX: 0, y: toView.height)
        UIView.animate(withDuration: animatTime, animations: {
            toView.transform = CGAffineTransform(translationX: 0, y: 0)
        }) { _ in
            transitionContext.completeTransition(true)
        }
    }
    
    // 消失动画
    fileprivate func dismissViewAnimation(transitionContext: UIViewControllerContextTransitioning) {
        dismissViewDefaultAnimation(transitionContext: transitionContext)
        
        
//        // 过渡view
//        guard let fromeView = transitionContext.view(forKey: .from) else {
//            return
//        }
//        let formeBackView = UIView(frame: fromeView.bounds)
//        formeBackView.backgroundColor = UIColor.black
//        fromeView.addSubview(formeBackView)
//        // 容器view
//        let containerView = transitionContext.containerView
//        // 取出model的控制器
//        guard let formVC = transitionContext.viewController(forKey: .from) as? ShowImageViewController else {
//            return
//        }
//        // 取出当前显示的cell
//        guard let cell = formVC.collectionView?.visibleCells.first as? ShowImageCollectionViewCell else {
//            return
//        }
//        guard let image = cell.currentImage.image else {
//            return
//        }
//        guard let window = UIApplication.shared.delegate?.window else {
//            return
//        }
//
//        let imageSize: CGSize = cell.currentImage.image?.size ?? .zero
//        var startFrame: CGRect = .zero
//        let imageHeight = imageSize.height / imageSize.width * Constant.screenWidth
//        if imageHeight > Constant.screenHeight {
//            startFrame.size.height = Constant.screenHeight
//            startFrame.size.width = imageSize.width / imageSize.height * Constant.screenHeight
//            startFrame.origin.y = 0
//            startFrame.origin.x = Constant.screenWidth/2 - startFrame.width/2
//        }else {
//            startFrame.size.width = Constant.screenWidth
//            startFrame.size.height = imageSize.height * startFrame.width / image.size.width
//            startFrame.origin.x = 0
//            startFrame.origin.y = Constant.screenHeight/2 - startFrame.height/2
//        }
//
//        // 新建过渡动画imageView
//        let animateImageView = UIImageView()
//        animateImageView.frame = startFrame
//        animateImageView.image = image
//        animateImageView.contentMode = .scaleAspectFill
//        animateImageView.clipsToBounds = true
//        containerView.addSubview(animateImageView)
//
//        guard let originalView = originalView1 else {
//            return
//        }
//
//        let endFrame = originalView.convert(originalView.bounds, to: window)
//        UIView.animate(withDuration: animatTime, animations: {
//            animateImageView.frame = endFrame
//            fromeView.alpha = 0
//        }) { _ in
//            transitionContext.completeTransition(true)
//            animateImageView.removeFromSuperview()
//            formeBackView.removeFromSuperview()
//        }
    }
    
    fileprivate func dismissViewDefaultAnimation(transitionContext: UIViewControllerContextTransitioning) {
        guard let fromeView = transitionContext.view(forKey: .from) else {
            return
        }
        fromeView.transform = CGAffineTransform(translationX: 0, y: 0)
        UIView.animate(withDuration: animatTime, animations: {
            fromeView.transform = CGAffineTransform(translationX: 0, y: fromeView.height)
        }) { _ in
            fromeView.transform = CGAffineTransform(translationX: 0, y: 0)
            transitionContext.completeTransition(true)
        }
    }
}
