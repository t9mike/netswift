//
//  RandomTests.swift
//  gsnet
//
//  Created by Gabor Soulavy on 20/11/2015.
//  Copyright © 2015 Gabor Soulavy. All rights reserved.
//

import XCTest
@testable import netswift

class RandomTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    /*
    func testNext_return() {

        let r = Random()
        var result: int = 0
        for _ in 0 ..< 10 {
            result = r.Next()
            XCTAssertGreaterThan(result, 0)
            XCTAssertLessThan(result, int.max)
        }
    }

    func testSample_return() {

        let r = Random()
        var result: double = 0
        for _ in 0 ..< 10 {
            result = r.Sample()
            XCTAssertGreaterThan(result, 0)
            XCTAssertLessThan(result, 1)
        }
    }
*/

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
