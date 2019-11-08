//
//  CRDTModelTests.swift
//  CRDTModelTests
//
//  Created by Atharva Vaidya on 11/7/19.
//  Copyright © 2019 Atharva Vaidya. All rights reserved.
//

import XCTest
@testable import CRDTModel

class CRDTModelTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testOverridingNode() {
        let hits = LWWCRDTSet<Int>()
        hits.add(node: CRDTNode<Int>(value: 1, timestamp: 1))
        hits.add(node: CRDTNode<Int>.init(value: 1, timestamp: 2))
        XCTAssertEqual(hits.count, 1)
        XCTAssertNotNil(hits.getNodeWith(value: 1))
        XCTAssertEqual(hits.getNodeWith(value: 1)?.timestamp, 2)
    }
    
    func testAddingNode() {
        let hits = LWWCRDTSet<Int>()
        hits.add(node: CRDTNode<Int>(value: 1, timestamp: 1))
        hits.add(node: CRDTNode<Int>.init(value: 10, timestamp: 2))
        XCTAssertEqual(hits.count, 2)
        XCTAssertNotNil(hits.getNodeWith(value: 1))
        XCTAssertNotNil(hits.getNodeWith(value: 10))
    }
    
    func testRemovingNodes() {
        let likes = LWWCRDTSet<String>()
        likes.add(node: CRDTNode<String>(value: "Atharva", timestamp: 1))
        likes.remove(node: CRDTNode<String>(value: "Atharva", timestamp: 2))
        
        XCTAssert(likes.result.isEmpty)
    }
    
    func testRemovalFailure() {
        let likes = LWWCRDTSet<String>()
        likes.add(node: CRDTNode<String>(value: "Atharva", timestamp: 7))
        likes.remove(node: CRDTNode<String>(value: "Atharva", timestamp: 3))
        XCTAssert(!likes.result.isEmpty)
    }

    func testEmptySet() {
        let emptySet = LWWCRDTSet<Int>()
        let result = emptySet.result
        XCTAssert(result.isEmpty)
    }
    
    func testSetOrder() {
        let likes = LWWCRDTSet<String>()
        likes.add(node: CRDTNode<String>(value: "Atharva", timestamp: 5))
        likes.add(node: CRDTNode<String>(value: "Bob", timestamp: 1))
        likes.remove(node: CRDTNode<String>(value: "Atharva", timestamp: 6))
        likes.add(node: CRDTNode<String>(value: "Atharva", timestamp: 1))
        
        let results = likes.result
        
        XCTAssertFalse(results.isEmpty)
        XCTAssertEqual(results.count, 1)
        
        XCTAssertEqual(results[0], CRDTNode<String>(value: "Bob", timestamp: 1))
    }
    
    //MARK:- Set Identity Functions Test
    func testSetIdempotence() {
        let set = LWWCRDTSet<Int>()
        set.add(node: CRDTNode<Int>(value: 1))
        XCTAssert(set == set + set, "LWWCRDTSet is not idempotent")
    }
    
    func testSetCommutativity() {
        let set1 = LWWCRDTSet<Int>()
        let set2 = LWWCRDTSet<Int>()
        
        set1.add(node: CRDTNode<Int>(value: 1))
        set2.add(node: CRDTNode<Int>(value: 2))
        
        XCTAssert(set1 + set2 == set2 + set1, "LWWCRDTSet is not commutative")
    }
    
    func testSetAssociativity() {
        let set1 = LWWCRDTSet<Int>()
        let set2 = LWWCRDTSet<Int>()
        let set3 = LWWCRDTSet<Int>()
        
        set1.add(node: CRDTNode<Int>(value: 1))
        set2.add(node: CRDTNode<Int>(value: 2))
        set3.add(node: CRDTNode<Int>(value: 3))
        
        let merge1 = set1 + (set2 + set3)
        let merge2 = (set1 + set2) + set3
        XCTAssertEqual(merge1, merge2, "LWWCRDTSet is not associative")
    }
    
    func testSetMerge() {
        let set1 = LWWCRDTSet<String>()
        let set2 = LWWCRDTSet<String>()
        let set3 = LWWCRDTSet<String>()
        
        set1.add(node: CRDTNode<String>(value: "Atharva", timestamp: 1))
        set2.add(node: CRDTNode<String>(value: "Bob", timestamp: 1))
        set3.add(node: CRDTNode<String>(value: "Billy", timestamp: 1))
        set3.remove(node: CRDTNode<String>(value: "Megan"))
        
        let mergedSet = set1 + set2 + set3
        
        XCTAssertEqual(mergedSet.count, 3)
        XCTAssertNotNil(mergedSet.getNodeWith(value: "Atharva"))
        XCTAssertNotNil(mergedSet.getNodeWith(value: "Bob"))
        XCTAssertNotNil(mergedSet.getNodeWith(value: "Billy"))
        XCTAssertNil(mergedSet.getNodeWith(value: "Megan"))
    }
}
