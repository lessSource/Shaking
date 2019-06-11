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

}
