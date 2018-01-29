//
//  Array.swift
//  Mybx
//
//  Created by Nabil Muthanna on 2017-10-29.
//  Copyright © 2017 Nabil Muthanna. All rights reserved.
//

import Foundation

extension Array {
    
    func at(index: Int) -> Element? {
        guard 0 <= index && index < count else {
            return nil
        }
        return self[index]
    }

}

extension Array where Element: Equatable {
    
    mutating func remove(_ item: Element) {
        if let index = self.index(of: item) {
            self.remove(at: index)
        }
    }
    
    mutating func remove(_ isRemoved: ((Element) -> Bool)) -> [Element] {
        var removedElements = [Element]()
        for item in self {
            if isRemoved(item) {
                self.remove(item)
                removedElements.append(item)
            }
        }
        return removedElements
    }
    
}










