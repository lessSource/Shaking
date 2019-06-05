//
//  Array+Extension.swift
//  SwiftNoteStudy
//
//  Created by Lj on 2018/12/17.
//  Copyright © 2018 lj. All rights reserved.
//

import UIKit

//MARK:- 防止数组越界
extension Array {
    subscript (safe index: Index) -> Element? {
        return (0 ..< count).contains(index) ? self[index] : nil
    }
    
    func safeObjectAtIndex(index: Int) -> Element? {
        return (0 ..< count).contains(index) ? self[index] : nil
    }
    
    mutating func insertToFirst(newElement: Element) {
        insert(newElement, at: 0)
    }
    
    func isLastIndex(index: Index) -> Bool {
        return index == count - 1
    }
    
    func isNotLastIndex(index: Int) -> Bool {
        return !isLastIndex(index: index)
    }
}

