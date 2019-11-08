//
//  LWWCRDTSet.swift
//  CRDTModel
//
//  Created by Atharva Vaidya on 11/8/19.
//  Copyright © 2019 Atharva Vaidya. All rights reserved.
//

import Foundation

class LWWCRDTSet<T: Hashable & Comparable> {
    
    var additions: [T : TimeInterval]
    var removals: [T : TimeInterval]
    
    init(value: T? = nil) {
        if let value = value {
            self.additions = [value : Date().timeIntervalSince1970]
        } else {
            self.additions = [:]
        }
        self.removals = [:]
    }
}
