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
    func showImage(_ imageArray: UIImage?, currentIndex: Int, delegate: ModelAnimationDelegate?) {
        let showImageVC = ShowImageViewController(imageArray: imageArray, currentIndex: currentIndex)
        showImageVC.transitioningDelegate = delegate
        showImageVC.modalPresentationStyle = .custom
        present(showImageVC, animated: true, completion: nil)
    }
}

class ModelAnimationDelegate: NSObject, UIViewControllerTransitioningDelegate {
    fileprivate var isPresentAnimatotion: Bool = true
    fileprivate var originalView: UIImageView!
    fileprivate let animatTime: TimeInterval = 0.3
    
    init(originalView: UIImageView) {
        self.originalView = originalView
        super.init()
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
        guard let image = originalView.image else {
            fatalError("there is no image at selectedImageView")
        }
        // 过渡View
        guard let toView = transitionContext.view(forKey: .to) else {
            return
        }
        let toBackView = UIView(frame: toView.bounds)
        toBackView.backgroundColor = UIColor.black
        toView.addSubview(toBackView)
        // 容器View
        let containerView = transitionContext.containerView
        // 过渡view添加到容器上
        toView.alpha = 0
        containerView.addSubview(toView)
        // 新建一个imageView添加到目标view之上，做为动画view
        let animateView = UIImageView()
        animateView.image = image
        animateView.contentMode = .scaleAspectFill
        animateView.clipsToBounds = true
        // 被选中的imageView到目标view上的坐标转换
        guard let window = UIApplication.shared.delegate?.window else {
            return
        }
        let originalFrame = originalView.convert(originalView.bounds, to: window)
        animateView.frame = originalFrame
        containerView.addSubview(animateView)
        
        let width = Constant.screenWidth
        let height = image.size.height * width / image.size.width
        let y = (Constant.screenHeight - image.size.height * width / image.size.width) * 0.5
        let endFrme = CGRect(x: 0, y: y, width: width, height: height)
        
        // 过渡动画
        UIView.animate(withDuration: animatTime, animations: {
            toView.alpha = 1
            animateView.frame = endFrme
        }) { _ in
            transitionContext.completeTransition(true)
            animateView.removeFromSuperview()
            toBackView.removeFromSuperview()
        }
    }
    
    // 消失动画
    fileprivate func dismissViewAnimation(transitionContext: UIViewControllerContextTransitioning) {
        // 过渡view
        guard let fromeView = transitionContext.view(forKey: .from) else {
            return
        }
        let formeBackView = UIView(frame: fromeView.bounds)
        formeBackView.backgroundColor = UIColor.black
        fromeView.addSubview(formeBackView)
        // 容器view
        let containerView = transitionContext.containerView
        // 取出model的控制器
        guard let formVC = transitionContext.viewController(forKey: .from) as? ShowImageViewController else {
            return
        }
        // 取出当前显示的cell
        guard let cell = formVC.collectionView?.visibleCells.first as? ShowImageCollectionViewCell else {
            return
        }
        guard let image = cell.currentImage.image else {
            return
        }
        guard let window = UIApplication.shared.delegate?.window else {
            return
        }
        let imageSize: CGSize = cell.currentImage.image?.size ?? .zero
        var height: CGFloat = 0.0
        if imageSize.width > Constant.screenWidth {
            height = (Constant.screenWidth / imageSize.width) * imageSize.height
        }else {
            height = (imageSize.width / Constant.screenWidth) * imageSize.height
        }
        
        // 新建过渡动画imageView
        let animateImageView = UIImageView()
        animateImageView.frame = CGRect(x: 0, y: Constant.screenHeight/2 - height/2, width: Constant.screenWidth, height: height)
        animateImageView.image = image
        animateImageView.contentMode = .scaleAspectFill
        animateImageView.clipsToBounds = true
        containerView.addSubview(animateImageView)

        let endFrame = originalView.convert(originalView.bounds, to: window)
        UIView.animate(withDuration: animatTime, animations: {
            animateImageView.frame = endFrame
            fromeView.alpha = 0
        }) { _ in
            transitionContext.completeTransition(true)
            animateImageView.removeFromSuperview()
            formeBackView.removeFromSuperview()
        }
    }
}
