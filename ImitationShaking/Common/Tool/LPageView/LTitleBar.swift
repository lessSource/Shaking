//
//  LTitleBar.swift
//  ImitationShaking
//
//  Created by less on 2019/6/13.
//  Copyright © 2019 study. All rights reserved.
//

import UIKit

class LTitleBar: UIView {

    public var titles: Array<String> = [String]()
    
    public var barItemTapClosure: ((_ index: IndexPath) -> ())?

    public var barIndexChangeClosure: ((_ index: Int) -> ())?
    // collectionView的布局
    fileprivate lazy var layout: LTitleItemLayout = LTitleItemLayout()
    // titleBar的布局
    fileprivate lazy var barLayout: LTitleBarLayout = LTitleBarLayout()
    
    fileprivate var selectedIndex: Int = 0
    
    fileprivate var bottomLine: UIView = UIView()
    
    fileprivate lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height), collectionViewLayout: self.layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(frame: CGRect, titleBarLayot: LTitleBarLayout) {
        self.init(frame: frame)
        backgroundColor = .white
        barLayout = titleBarLayot
        selectedIndex = 0
    }
    
    // MARK: - layout
    fileprivate func layoutViewBarLayout(titleBarLayout: LTitleBarLayout) {
        layout.itemSizeClosure = ({ index -> CGSize in
            return titleBarLayout.barItemSize
        })
        collectionView.bounces = titleBarLayout.barBounces
        collectionView.alwaysBounceHorizontal = titleBarLayout.barAlwaysBounceHorizontal
        addSubview(collectionView)
        
        collectionView.register(LTitleItemCell.self, forCellWithReuseIdentifier: LTitleItemCell.identifire)
        barIndexChangeClosure = { [weak self] index in
            if self?.selectedIndex == index {
                return
            }
            // 需要完成布局，然后才能进行准确的滚动
            self?.collectionView.layoutSubviews()
            self?.collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: UICollectionView.ScrollPosition(), animated: true)
            self?.selectedIndex = index
            self?.collectionView.reloadData()
        }
        
        // 底线
        if titleBarLayout.needBarBottomLine {
            if !bottomLine.isDescendant(of: self) {
                addSubview(bottomLine)
            }
            bottomLine.backgroundColor = titleBarLayout.barBottomLineColor
            bottomLine.frame = CGRect(x: 0, y: bounds.height - 0.5, width: bounds.width, height: 0.5)
        }
        
    }
}

extension LTitleBar: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: LTitleItemCell = collectionView.dequeueReusableCell(withReuseIdentifier: LTitleItemCell.identifire, for: indexPath) as! LTitleItemCell
        cell.configItemByTitle(title: titles[indexPath.item], titleFont: barLayout.barTextFont, titleSelectedFont: barLayout.barTextSelectedFont, textColor: barLayout.barTextColor, textSelectedColor: barLayout.barTextSelectedColor, needFollowLinde: barLayout.needBarBottomLine, followLineColor: barLayout.barFollowLineColor, followPercent: barLayout.barFollowLinePercent, index: indexPath, selectedIndex: selectedIndex)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let closure = barItemTapClosure {
            closure(indexPath)
        }
    }
}


class LTitleItemCell: UICollectionViewCell {
    
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    fileprivate lazy var followLineLabel: UILabel = {
        let label = UILabel()
        label.clipsToBounds = true
        label.layer.cornerRadius = 1
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - layout
    fileprivate func layoutView() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(followLineLabel)
    }
    
    public func configItemByTitle(title: String, titleFont: UIFont, titleSelectedFont: UIFont, textColor: UIColor, textSelectedColor: UIColor, needFollowLinde: Bool, followLineColor: UIColor, followPercent: CGFloat, index: IndexPath, selectedIndex: Int) {
        followLineLabel.backgroundColor = followLineColor
        titleLabel.font = titleFont
        titleLabel.text = title
        titleLabel.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
        
        if index.row == selectedIndex {
            titleLabel.textColor = textSelectedColor
            titleLabel.font = titleSelectedFont
        }else {
            titleLabel.textColor = textColor
            titleLabel.font = titleFont
        }
        bottomLineHandleByNeedLine(needFollowLinde, isSelected: index.row == selectedIndex, percent: followPercent)
    }
    
    fileprivate func bottomLineHandleByNeedLine(_ needLine: Bool, isSelected: Bool, percent: CGFloat) {
        let percentC: CGFloat = percent < 0 ? 0 : percent > 1 ? 1 : percent
        if !needLine {
            followLineLabel.isHidden = true
            return
        }
        let lineWidth: CGFloat = percentC * width
        followLineLabel.frame = CGRect(x: (width - lineWidth)/2, y: height - 2.5, width: lineWidth, height: 2)
        followLineLabel.isHidden = isSelected
    }
    
}



