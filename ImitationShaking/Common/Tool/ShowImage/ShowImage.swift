//
//  ShowImage.swift
//  ImitationShaking
//
//  Created by Lj on 2019/6/25.
//  Copyright © 2019 study. All rights reserved.
//

import Foundation

struct ShowImageConfiguration {
    /** 数据源 */
    var dataArray: [LMediaResourcesModel]
    /** 当前数据 */
    var currentIndex: Int
    /** 是否带删除 */
    var isDelete: Bool
    /** 是否可以选择 */
    var isSelect: Bool
    /** 最多可以选择 */
    var maxCount: Int
    /** 是否加载原图 */
    var isOriginalImage: Bool
    
    init(dataArray: [LMediaResourcesModel], currentIndex: Int, isDelete: Bool = false, isSelect: Bool = false, maxCount: Int = 0, isOriginalImage: Bool = true) {
        self.dataArray = dataArray
        self.currentIndex = currentIndex
        self.isDelete = isDelete
        self.isSelect = isSelect
        self.maxCount = maxCount
        self.isOriginalImage = isOriginalImage
    }
}


protocol ShowImageProtocol { }

extension ShowImageProtocol where Self: UIViewController, Self: UIViewControllerTransitioningDelegate {
    // 带动画的显示大图 ---- 必须遵循UIViewControllerTransitioningDelegate
    func showImage(_ configuration: ShowImageConfiguration, delegate: ModelAnimationDelegate? = nil, formVC: UIViewController? = nil) {
        assert(configuration.dataArray.count != 0, "数组不能为空！！！！")
        assert(configuration.dataArray.count > configuration.currentIndex, "序号能不能大于数组数量！！！！")
        let showImageVC = ShowImageViewController(configuration: configuration)
        showImageVC.imageDelegate = formVC as? ShowImageVCDelegate
        showImageVC.transitioningDelegate = delegate
        if let _ = delegate {
            showImageVC.modalPresentationStyle = .custom
        }else {
            showImageVC.modalTransitionStyle = .crossDissolve
        }
        present(showImageVC, animated: true, completion: nil)
    }
    
    
}

class ModelAnimationDelegate: NSObject, UIViewControllerTransitioningDelegate {
    fileprivate var isPresentAnimatotion: Bool = true
    // 动画时间
    fileprivate let animatTime: TimeInterval = 0.3
    // 父视图
    fileprivate var superView: UIView?
    // 序号
    fileprivate var currentIndex: Int = 0
    // 点击Image
    fileprivate var contentImage: UIImageView?
    
    init(contentImage: UIImageView? = nil,superView: UIView? = nil, currentIndex: Int = 0) {
        self.superView = superView
        self.currentIndex = currentIndex
        self.contentImage = contentImage
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
        // 获取view
        guard let `contentImage` = contentImage, let image = contentImage.image,let toView = transitionContext.view(forKey: .to),let window = UIApplication.shared.delegate?.window else {
            presentViewDefaultAnimation(transitionContext: transitionContext)
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
        animateView.image = contentImage.image
        animateView.contentMode = .scaleAspectFill
        animateView.clipsToBounds = true
        // 被选中的imageView到目标view上的坐标转换
        
        let originalFrame = contentImage.convert(contentImage.bounds, to: window)
        animateView.frame = originalFrame
        containerView.addSubview(animateView)

        // endFrame
        var endFrame: CGRect = .zero
        let imageHeight = image.size.height / image.size.width * Constant.screenWidth
        if imageHeight > Constant.screenHeight {
            endFrame.size.height = Constant.screenHeight
            endFrame.size.width = image.size.width / image.size.height * Constant.screenHeight
            endFrame.origin.y = 0
            endFrame.origin.x = Constant.screenWidth/2 - endFrame.width/2
        }else {
            endFrame.size.width = Constant.screenWidth
            endFrame.size.height = image.size.height * endFrame.width / image.size.width
            endFrame.origin.x = 0
            endFrame.origin.y = Constant.screenHeight/2 - endFrame.height/2
        }
        // 过渡动画
        UIView.animate(withDuration: animatTime, animations: {
            animateView.frame = endFrame
            toView.alpha = 1
        }) { _ in
            transitionContext.completeTransition(true)
            animateView.removeFromSuperview()
            toBackView.removeFromSuperview()
        }
    }
    
    // 默认显示动画
    fileprivate func presentViewDefaultAnimation(transitionContext: UIViewControllerContextTransitioning) {
        guard let toView = transitionContext.view(forKey: .to) else { return }
        let containerView = transitionContext.containerView
        containerView.addSubview(toView)
        toView.transform = CGAffineTransform(translationX: toView.width, y: 0)
        UIView.animate(withDuration: animatTime, animations: {
            toView.transform = CGAffineTransform(translationX: 0, y: 0)
        }) { _ in
            transitionContext.completeTransition(true)
        }
    }
    
    // 消失动画
    fileprivate func dismissViewAnimation(transitionContext: UIViewControllerContextTransitioning) {
        // 获取一系列view
        guard let formVC = transitionContext.viewController(forKey: .from) as? ShowImageViewController, let cell = formVC.collectionView?.visibleCells.first as? ShowImageCollectionViewCell,let image = cell.currentImage.image ,let window = UIApplication.shared.delegate?.window,let _ = contentImage else {
            dismissViewDefaultAnimation(transitionContext: transitionContext)
            return
        }
        var endView: UIView?
        if let collectionView = superView as? UICollectionView {
            let indexPath = IndexPath(item: formVC.currentIndex, section: 0)
            endView = collectionView.cellForItem(at: indexPath)
        }else {
            endView = superView?.subviews[formVC.currentIndex]
        }
        
        if endView == nil {
            dismissViewDefaultAnimation(transitionContext: transitionContext)
            return
        }
        
        // 过渡view
        guard let fromeView = transitionContext.view(forKey: .from) else { return }
        let formeBackView = UIView(frame: fromeView.bounds)
        formeBackView.backgroundColor = UIColor.black
        fromeView.addSubview(formeBackView)
        // 容器view
        let containerView = transitionContext.containerView


        let imageSize: CGSize = cell.currentImage.image?.size ?? .zero
        var startFrame: CGRect = .zero
        let imageHeight = imageSize.height / imageSize.width * Constant.screenWidth
        if imageHeight > Constant.screenHeight {
            startFrame.size.height = Constant.screenHeight
            startFrame.size.width = imageSize.width / imageSize.height * Constant.screenHeight
            startFrame.origin.y = 0
            startFrame.origin.x = Constant.screenWidth/2 - startFrame.width/2
        }else {
            startFrame.size.width = Constant.screenWidth
            startFrame.size.height = imageSize.height * startFrame.width / image.size.width
            startFrame.origin.x = 0
            startFrame.origin.y = Constant.screenHeight/2 - startFrame.height/2
        }

        // 新建过渡动画imageView
        let animateImageView = UIImageView()
        animateImageView.frame = startFrame
        animateImageView.image = image
        animateImageView.contentMode = .scaleAspectFill
        animateImageView.clipsToBounds = true
        containerView.addSubview(animateImageView)
        let endFrame: CGRect = endView!.convert(endView!.bounds, to: window)
        
        UIView.animate(withDuration: animatTime, animations: {
            animateImageView.frame = endFrame
            fromeView.alpha = 0
        }) { _ in
            transitionContext.completeTransition(true)
            animateImageView.removeFromSuperview()
            formeBackView.removeFromSuperview()
        }
    }
    
    fileprivate func dismissViewDefaultAnimation(transitionContext: UIViewControllerContextTransitioning) {
        guard let fromeView = transitionContext.view(forKey: .from) else {
            return
        }
        fromeView.transform = CGAffineTransform(translationX: 0, y: 0)
        UIView.animate(withDuration: animatTime, animations: {
            fromeView.transform = CGAffineTransform(translationX: fromeView.width, y: 0)
        }) { _ in
            fromeView.transform = CGAffineTransform(translationX: 0, y: 0)
            transitionContext.completeTransition(true)
        }
    }
}
