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
            self.additions = [value : 0]
        } else {
            self.additions = [:]
        }
        self.removals = [:]
    }
    
    //Computed Properties
     var description: String {
         return "\(result)"
     }
     
     var result: [CRDTNode<T>] {
         return additions
             .filter({
                 if let removed = removals[$0.key], removed >= $0.value {
                     return false
                 } else {
                     return true
                 }
             })
             .map({ CRDTNode<T>(value: $0.key, timestamp: $0.value) })
             .sorted()
     }
     
     var count: Int {
         return result.count
     }
    
    //MARK:- Convenience Methods
    
    public subscript(index: Int) -> CRDTNode<T>? {
        guard index < result.count && index >= 0 else {
            return nil
        }
        
        return result[index]
    }
    
    func getNodeWith(value: T) -> CRDTNode<T>? {
        return result.first(where: { $0.value == value })
    }
    
    func contains(element: T) -> Bool {
        return additions[element] != nil && removals[element] == nil
    }
    
    //MARK:- Additon and Removal Operations
    
    func add(node: CRDTNode<T>) {
        if let oldNodeTimestamp = additions[node.value] {
            if oldNodeTimestamp < node.timestamp {
                additions[node.value] = node.timestamp
            }
        } else {
            additions[node.value] = node.timestamp
        }
    }
    
    func remove(node: CRDTNode<T>) {
        if let oldNoteTimestamp = removals[node.value] {
            if oldNoteTimestamp < node.timestamp {
                removals[node.value] = node.timestamp
            }
        } else {
            removals[node.value] = node.timestamp
        }
    }
    
    func merge(set: LWWCRDTSet<T>) {
        set.additions.forEach({
            self.add(node: CRDTNode<T>(value: $0.key, timestamp: $0.value))
        })
        
        set.removals.forEach({
            self.remove(node: CRDTNode<T>(value: $0.key, timestamp: $0.value))
        })
    }

}
