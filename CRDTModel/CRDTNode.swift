//
//  CRDTNode.swift
//  CRDTModel
//
//  Created by Atharva Vaidya on 11/8/19.
//  Copyright © 2019 Atharva Vaidya. All rights reserved.
//

import Foundation

class CRDTNode<T: Hashable & Comparable>: Comparable, CustomStringConvertible {
    let value: T
    let timestamp: TimeInterval
    
    var description: String {
        return "\(value)"
    }
    
    init(value: T, timestamp: TimeInterval = Date().timeIntervalSince1970) {
        self.value = value
        self.timestamp = timestamp
    }
    
    static func < (lhs: CRDTNode, rhs: CRDTNode) -> Bool {
        return lhs.value < rhs.value
    }
        
    static func == (lhs: CRDTNode, rhs: CRDTNode) -> Bool {
        return lhs.value == rhs.value
    }
}
