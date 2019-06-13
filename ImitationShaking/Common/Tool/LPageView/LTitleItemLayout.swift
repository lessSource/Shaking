//
//  LTitleItemLayout.swift
//  ImitationShaking
//
//  Created by less on 2019/6/13.
//  Copyright © 2019 study. All rights reserved.
//

import UIKit

class LTitleItemLayout: UICollectionViewLayout {

    // 获取item大小
    public var itemSizeClosure: ((_ indexPath: IndexPath) -> (CGSize))?
    // 记录X值
    fileprivate var itemX: CGFloat = 0
    // 记录高
    fileprivate var itemHeight: CGFloat = 0
    // 保存每一个item的attributes
    fileprivate lazy var attributesArray: Array<UICollectionViewLayoutAttributes> = [UICollectionViewLayoutAttributes]()
    
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 当collection开始布局时调用
    override func prepare() {
        super.prepare()
        itemX = 0
        itemHeight = 0
        attributesArray.removeAll()
        
        // 获取bar中cell总个数
        let itemInSection0 = collectionView?.numberOfItems(inSection: 0) ?? 0
        
        // 为每一个cell 创建一个依赖
        for i in 0..<itemInSection0 {
            let attributes = layoutAttributesForItem(at: IndexPath(item: i, section: 0)) ?? UICollectionViewLayoutAttributes()
            attributesArray.append(attributes)
        }
    }
    
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        // 根据indexPath获取item的attributes
        let attrubutes: UICollectionViewLayoutAttributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        
        // 从外面获取每个cell的高度
        var itemSize = CGSize.zero
        if let closure = itemSizeClosure {
            itemSize = closure(indexPath)
        }
        
        // 设置attributes
        attrubutes.frame = CGRect(x: itemX, y: 0, width: itemSize.width, height: itemSize.height)
        itemX += itemSize.width
        itemHeight = itemSize.height
        
        return attrubutes
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        // 当bounds变化时不需要重绘图
        return false
    }
    
    // 计算cellectionView的contentSize
    override var collectionViewContentSize: CGSize {
        return CGSize(width: itemX, height: itemHeight)
    }
    
    // 返回rect范围内item的attributes
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attributesArray
    }
    
    
    
    
}
