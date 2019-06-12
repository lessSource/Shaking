//
//  LPageView.swift
//  ImitationShaking
//
//  Created by Lj on 2019/6/11.
//  Copyright © 2019 study. All rights reserved.
//

enum LPageViewStyle {
    /** 表头优先，只要header不在吸顶状态，所有列表都会相对于header复原到最顶端 */
    case headerFirst
    /** 列表优先，不管header怎么变动，所有的列表都会保持自己上次与header的相对位置 */
    case tablesFiret
}

protocol PagesViewDataScorce: NSObjectProtocol {
    
    
    /**
     标题数组
     
     - returns: array
     */
    func pagesViewPageTitles() -> Array<String>
    
    /**
     子控制器
     
     - parameter pagesView: LPageView
     
     - parameter index: 索引
     
     - returns: 子控制器
     
     */
    func pagesViewChildController(pagesView: LPagesView, forIndex index: Int) -> UIViewController
    
    /**
     已经跳到的当前界面
     
     - parameter pageController: 当前控制器
     
     - parameter title: 标题
     
     - parameter index
     
     */
    func pagesViewDidChangeTo(pageController: UIViewController, pageTitle title: String, pageIndex index: Int)
    
    /**
     竖直滚动监听(只有在有header时才会调用，且变动范围为header的高度范围)
     
     - parameter changedy: 竖直offset.y
     
     */
    func pagesViewVerticalScrollOffsetyChanged(_ changedy: CGFloat)
    
    /**
     水平滚动监听
     
     - parameter changedx: 竖直offset.x
     
     */
    func pagesViewVerticalScrollOffsetxChanged(_ changedx: CGFloat)

    /**
     标题栏右边按钮点击事件
     
     */
    func pagesViewTitleBarRightBtnTap()
}


import UIKit

class LPagesView: UIView {
    enum HeaderContentStatus {
        case top       // headerContenter到达顶端
        case changeing // headerContenter变化中
        case ceiling   // headerContenter吸顶
    }
    
    enum DragingStatus {
        case up   // 向上拖动
        case dowm // 向下拖动
    }
    
    enum LeftScrollOffsetLockStatus {
        case unLook
        case looked
    }
    
    enum RightScrollOffsetLockStatus {
        case unLook
        case looked
    }
    
    
    // 设置header
    public var headerView: UIView = UIView()
    
    // 最大缓存页数，默认不限制
    public var cacheNumber: Int = 0
    
    // 靠边后是否可滑动（默认为false）
    public var bounces: Bool = false
    
    // 需要通过header上下滑动列表（默认为false）
    public var needSlideByHeader: Bool = false
    
    // slideView 上方空余空间 （值要大于0）
    public var degeInSetTop: CGFloat = 0

    fileprivate weak var dataSource: PagesViewDataScorce?
    
    // 子控制器容器控制器
    fileprivate var currentController = UIViewController()
    
    // 子视图容器视图
    fileprivate lazy var pagesContener: UIScrollView = {
        let scrollView = UIScrollView(frame: self.bounds)
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            self.currentController.automaticallyAdjustsScrollViewInsets = false
        }
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.alwaysBounceHorizontal = false
        scrollView.bounces = false
        scrollView.delegate = self
        return scrollView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect, dataScorce: PagesViewDataScorce, page: Int, titleBarLayout: LTitleBarLayout, style: LPageViewStyle) {
        self.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- public
    // 缓存自控制器
    public func dequeueReusablePage(forIndex index: Int) -> UIViewController {
        return UIViewController()
    }
    
    // 定位到某页
    public func jumptoPage(page: Int) {
        
    }
    
    // 刷新控制器列表，并定位到某页
    public func reloadataToPage(page: Int) {
        
    }
}


extension LPagesView: UIScrollViewDelegate {
    
}
