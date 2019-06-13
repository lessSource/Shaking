//
//  LHeaderContentView.swift
//  ImitationShaking
//
//  Created by Lj on 2019/6/12.
//  Copyright © 2019 study. All rights reserved.
//

import UIKit

class LHeaderContentView: UIView {

    public var titleBarItemTag: ((_ index: IndexPath) -> ())?
    
    public var titleBarTitles: Array = [String]() {
        didSet {
            self.bar.titles = titleBarTitles
        }
    }
    
    public var pagesHeaderEdgeTop: CGFloat = 0 {
        didSet {
            self.headerEdgeTop = pagesHeaderEdgeTop > 0 ? pagesHeaderEdgeTop : 0
            resetFrame()
        }
    }
    
    // 总高度 （headerBarHeight + headerHeight）
    private(set) var headerContentHeight: CGFloat = 0
    // slideBar的高度
    private(set) var headerBarHeight: CGFloat = 0
    // 所赋值的header的高度
    private(set) var headerHeight: CGFloat = 0
    // header的上方空余
    private(set) var headerEdgeTop: CGFloat = 0
    // slideBar悬停上边距
    private(set) var barMarginTop: CGFloat = 0
    
    fileprivate var bar: LTitleBar = LTitleBar()
    
    fileprivate lazy var headerView: UIView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect, titleBarLayout: LTitleBarLayout) {
        self.init(frame: frame)
        let itemSizeHeight = titleBarLayout.needBar ? titleBarLayout.barItemSize.height : 0
        headerBarHeight = itemSizeHeight > 0 ? itemSizeHeight : 0
        headerHeight = 0
        headerEdgeTop = 0
        headerContentHeight = headerHeight + headerBarHeight + headerEdgeTop
        barMarginTop = titleBarLayout.barMarginTop > 0 ? titleBarLayout.barMarginTop : 0
        
        if headerBarHeight > 0 {
            bar = LTitleBar(frame: CGRect(x: 0, y: 0, width: width, height: headerBarHeight), titleBarLayot: titleBarLayout)
            addSubview(bar)
            
            bar.barItemTapClosure = { [weak self] index in
                if let colour = self?.titleBarItemTag {
                    colour(index)
                }
            }
        }
        resetFrame()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func pagesHeder(_ view: UIView) -> CGFloat {
        headerView.removeFromSuperview()
        self.headerView = view
        if headerView.isDescendant(of: self) {
            addSubview(headerView)
        }
        resetFrame()
        return headerHeight
    }
    
    public func titleBarChanged(to index: Int) {
        if let closure = bar.barIndexChangeClosure {
            closure(index)
        }
    }
    
    fileprivate func resetFrame() {
        if headerView.isDescendant(of: self) {
            var headerFrame = headerView.frame
            headerFrame.origin.x = 0
            headerFrame.origin.y = headerEdgeTop
            headerFrame.size.width = width
            headerView.frame = headerFrame
            headerHeight = headerFrame.height
        }
        
        var barFrame = bar.frame
        barFrame.origin.x = 0
        barFrame.origin.y = headerView.isDescendant(of: self) ? headerView.frame.maxY : headerEdgeTop
        barFrame.size.width = width
        bar.frame = barFrame
        headerBarHeight = barFrame.height
        
        var cFrame = bounds
        let headerWidth = width
        let headerContentHeight = headerHeight + headerBarHeight + headerEdgeTop
        
        cFrame.size.width = headerWidth
        cFrame.size.height = headerContentHeight
        frame = cFrame
        self.headerContentHeight = cFrame.height
    }

}
