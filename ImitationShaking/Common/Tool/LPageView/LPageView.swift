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
    
    // 缓存
    fileprivate var cache: LPagesCache = LPagesCache()
    
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
    
    // 头部容器视图
    fileprivate var headerContener: LHeaderContentView!
    
    fileprivate var style: LPageViewStyle = .headerFirst
    
    deinit {
        // 清除监听
        // 清除缓存
    }
    
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
    
    // MARK: - 清除
    // 清除监听
    fileprivate func clearKVO() {
        while cache.cachesVC.count > 0 {
            
        }
    }
    // 清除缓存顺序表及对应对象
    fileprivate func clearStack() {
        while cache.cachesTable.count > 0 {
            popDataOnStack()
        }
    }
    
    // 数据出缓存（同时删除对应的控制器）
    fileprivate func popDataOnStack() {
        guard let title = cache.cachesTable.last, let _ = cache.cachesVC[title] else {
            return
        }
        cancelPageVCByTitle(title)
    }
    
    // 去掉被删掉的子控制器及缓存
    fileprivate func cancelPageVCByTitle(_ title: String) {
        guard let pageVC = cache.cachesVC[title] else { return }
        pageVC.view.removeFromSuperview()
//        pageVC.view = nil
        pageVC.willMove(toParent: nil)
        pageVC.removeFromParent()
        cache.cachesVC.removeValue(forKey: title)
        cache.cachesSView.removeValue(forKey: title)
        cache.cachesTable.removeAll { $0 == title }
        cache.cachesHeadery.removeValue(forKey: title)
    }
    
    // MARK: - 缓存
    // headery
    fileprivate func cacheHeaderyForPageTitle(title: String) {
        cache.cachesHeadery.updateValue(headerContener.y, forKey: title)
    }
    
    // 控制器
    fileprivate func cachePageVc(pageVC: UIViewController, title: String) {
        cache.cachesVC.updateValue(pageVC, forKey: title)
    }
    
    
    
    // MARK: - 获取scrollView
    // 找到对应控制器中的scrollView
    fileprivate func scrollViewInPageVC(pageVC: UIViewController) -> UIScrollView? {
        var scrollV: UIScrollView?
        if pageVC.view is UIScrollView {
            scrollV = pageVC.view as? UIScrollView
        }else {
            for view in pageVC.view.subviews {
                if view is UIScrollView {
                    scrollV = view as? UIScrollView
                    break
                }
            }
        }
        
        if #available(iOS 11.0, *) {
            scrollV?.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        
        assert(scrollV == nil, "控制器中不包含可滚动控件")

        return scrollV
    }
    
    // 找到title对应的scrollView
    fileprivate func scrollViewByTitle(title: String) -> UIScrollView? {
        var scrollV: UIScrollView?
        scrollV = cache.cachesSView[title] as? UIScrollView
        
        if scrollV == nil {
            if let vc = cache.cachesVC[title] {
                scrollV = scrollViewInPageVC(pageVC: vc)
            }
        }
        
        if let scrollVC = scrollV {
            cache.cachesSView.updateValue(scrollVC, forKey: title)
        }
        
        return scrollV
    }
    
    // MARK: - 滑动
    // 情况1：更改界面时同步（根据headerContent的y去同步当前和左右三个界面的offset）。
    // 情况2：上下滚动子tableview时联动（根据该tableview的contentOffset.y联动左右两边的子tableview的contentOffset.y）。
    
    // 情况1 (同步)
    fileprivate func synchronizeCurrentPageWithRightAndLeftWhenChangeToPage(page: Int) {
        // headerContener的高度（header + bar）
        let HC_Height = headerContener.headerContentHeight
        
        // headerTitleBar的高度
        let HB_Height = headerContener.headerBarHeight
        
        // bar margin to top
        let HB_Top = headerContener.barMarginTop < 0 ? 0 : headerContener.barMarginTop
        
        // headerContent的y
        let header_y = headerContener.y
        
        // 当headercontener没有变动空间时之间返回
        if HB_Top >= HC_Height - HB_Height { return }
        
        // 所需同步数组
        var needSynArray: Array<String> = [String]()
        
        // 当前视图
        needSynArray.append(cache.cachesTitles[page])
        
        // 左边视图
        if page - 1 > 0 {
            needSynArray.append(cache.cachesTitles[page - 1])
        }
        
        // 右边视图
        if page + 1 < cache.cachesTitles.count {
            needSynArray.append(cache.cachesTitles[page + 1])
        }
        
        if style == .headerFirst {
            // 表头优先时
            for item in needSynArray {
                if let childS: UIScrollView = scrollViewByTitle(title: item) {
                    // 子滚动页的offset_Y
                    let childS_y = childS.contentOffset.y
                    
                    if header_y >= 0 {
                        if childS_y != -HB_Height {
                            childS.contentOffset = CGPoint(x: 0, y: -HC_Height)
                        }
                    }else if header_y > HB_Height + HB_Top - HC_Height && header_y < 0 && childS.contentOffset.y != -HC_Height - header_y {
                        childS.contentOffset = CGPoint(x: 0, y: -HC_Height - header_y)
                    }else if header_y <= HB_Height + HB_Top - HC_Height {
                        if childS_y <= -HB_Height -  HB_Top && childS_y != -HB_Height - HB_Top {
                            childS.contentOffset = CGPoint(x: 0, y: -HB_Height - HB_Top)
                        }
                    }
                }
                
            }
        }else if style == .tablesFiret {
            // 列表优先时
            for item in needSynArray {
                if let childS = scrollViewByTitle(title: item) {
                    var cache_H_Y: CGFloat = 0
                    if let cacheNum = cache.cachesHeadery[item] {
                        cache_H_Y = cacheNum as? CGFloat ?? 0
                    }else {
                        cacheHeaderyForPageTitle(title: item)
                        cache_H_Y = header_y
                    }
                    
                    // 子滚动页的offset_Y
                    let child_y = childS.contentOffset.y
                    
                    if header_y >= 0 {
                        // -HC_Height - cache_H_Y 是同步之前的headerContener偏移，由于当前child_Y是同步之前的，所以y一定要和之前的headerContener偏移比较
                        if child_y <= -HC_Height - cache_H_Y {
//                            childS.contentOffset = child_y
                        }
                    }
                }
            }
        }
        
    }
    
    // 情况2 (联动)
    fileprivate func synchronizeRightAndLeftWhenScrollByHCStatus(status: HeaderContentStatus, distance: CGFloat, page: Int) {
        
    }
}


extension LPagesView: UIScrollViewDelegate {
    
}
