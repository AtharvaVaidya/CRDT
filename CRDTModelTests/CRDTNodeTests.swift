//
//  CRDTNodeTests.swift
//  CRDTModelTests
//
//  Created by Atharva Vaidya on 11/8/19.
//  Copyright © 2019 Atharva Vaidya. All rights reserved.
//

import XCTest
@testable import CRDTModel

class CRDTNodeTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    //MARK:- Tests for CRDT Node
    func testEquality() {
        let node1 = CRDTNode<String>(value: "Atharva", timestamp: 1)
        let node2 = CRDTNode<String>(value: "Atharva", timestamp: 1)
        
        XCTAssertEqual(node1, node2, "Failed equality test")
    }
    
    func testLessThanOperator() {
        let node1 = CRDTNode<Int>(value: 1, timestamp: 1)
        let node2 = CRDTNode<Int>(value: 1, timestamp: 2)
        let node3 = CRDTNode<Int>(value: 2, timestamp: 2)
        
        XCTAssert(node1 < node3, "Failed test for less than operator")
        XCTAssert(node2 < node3, "Failed test for less than operator")
    }
    
    func testGreaterThanOperator() {
        let node1 = CRDTNode<Int>(value: 1, timestamp: 1)
        let node2 = CRDTNode<Int>(value: 1, timestamp: 2)
        let node3 = CRDTNode<Int>(value: 2, timestamp: 2)
        
        XCTAssert(node3 > node1, "Failed test for greater than operator")
        XCTAssert(node3 > node2, "Failed test for greater than operator")
    }
    
    func testNodeObjectEquivalance() {
        let node1 = CRDTNode<String>(value: "Atharva", timestamp: 1)
        let node2 = CRDTNode<String>(value: "Atharva", timestamp: 1)
        
        XCTAssert(node1.isEqualToObject(node: node2))
    }
    
    func testTimestampFunctions() {
        let node1 = CRDTNode<String>(value: "Atharva", timestamp: 1)
        let node2 = CRDTNode<String>(value: "Atharva", timestamp: 1)
        let node3 = CRDTNode<String>(value: "Bob", timestamp: 10)
        
        XCTAssert(node1.happenedAtTheSameTimeAs(node: node2))
        XCTAssert(node3.happenedAfter(node: node1))
        XCTAssert(node2.happenedBefore(node: node3))
    }
}
