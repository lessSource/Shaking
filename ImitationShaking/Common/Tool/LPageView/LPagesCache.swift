//
//  LPagesCache.swift
//  ImitationShaking
//
//  Created by less on 2019/6/12.
//  Copyright © 2019 study. All rights reserved.
//

import UIKit

struct LPagesCache {
    
    // 子控制器缓存
    var cachesVC: Dictionary = [String: UIViewController]()
    // 子控制器ScrollView缓存
    var cachesSView: Dictionary = [String: Any]()
    // 每个页面变动前对应的headery
    var cachesHeadery: Dictionary = [String: Any]()
    // 所有标题缓存
    var cachesTitles: Array = [String]()
    
    // 当前缓存顺序表
    var cachesTable: Array = [String]()
    // 当前所有添加了观察者的对象标题
    var cachesKVO: Array = [String]()
}
