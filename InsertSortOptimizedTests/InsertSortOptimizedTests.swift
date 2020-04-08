//
//  InsertSortOptimizedTests.swift
//  InsertSortOptimizedTests
//
//  Created by DDragutan on 4/6/20.
//  Copyright © 2020 DDragutan. All rights reserved.
//

import XCTest
@testable import InsertSortOptimized

class InsertSortOptimizedTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testOneBillion() throws {
        testRandomizedArray(arraySize: 1_000_000_000, cyclesToRun: 1)
    }

    func testOneHundredMillion() throws {
        testRandomizedArray(arraySize: 100_000_000, cyclesToRun: 10)
    }

    func testTenMillion() throws {
        testRandomizedArray(arraySize: 10_000_000, cyclesToRun: 10)
    }

    func testOneMillion() throws {
        testRandomizedArray(arraySize: 1_000_000, cyclesToRun: 10)
    }

    func testOneHundredThousand() throws {
        testRandomizedArray(arraySize: 100_000, cyclesToRun: 20)
    }

    func testTenThousand() throws {
        testRandomizedArray(arraySize: 10_000, cyclesToRun: 50)
    }

    func testOneThousand() throws {
        testRandomizedArray(arraySize: 1_000, cyclesToRun: 50)
    }

    private func testRandomizedArray(arraySize: Int, cyclesToRun: Int) {
        var isoTimeAvg:Double = 0
        var swiftTimeAvg:Double = 0

        (0...cyclesToRun).forEach { _ in
            let a = getRandomizedArray(size: arraySize)
            var copy = Array(a)

            var startTime = CFAbsoluteTimeGetCurrent()
            insertionSortOptimized(&copy)
            isoTimeAvg += CFAbsoluteTimeGetCurrent() - startTime

            copy = Array(a)
            startTime = CFAbsoluteTimeGetCurrent()
            copy.sort()
            swiftTimeAvg += CFAbsoluteTimeGetCurrent() - startTime
        }
        
        print("isoTimeAvg: \(isoTimeAvg/Double(cyclesToRun))")
        print("swiftTimeAvg: \(swiftTimeAvg/Double(cyclesToRun))")
    }
    
    
    func testBinarySearchForNearest() {
        (0..<100).forEach { _ in
            var a:[Int] = []
            (0...1_000).forEach { _ in
                a.append(Int(arc4random()))
            }
            
            a = a.sorted()

            let max = a[a.count-1] + 1
            let min = a[0] - 1
            let mid = min + (max - min) / 2

            var index = binarySearchForNearest(to: min, in: a)
            XCTAssert(index == 0, "binarySearchForNearest failed to find min")

            index = binarySearchForNearest(to: max, in: a)
            XCTAssert(index == a.count, "binarySearchForNearest failed to find max")

            index = binarySearchForNearest(to: mid, in: a)
            XCTAssert(index <= a.count && index != 0 , "binarySearchForNearest failed to find mid")
        }
    }



    private func getRandomizedArray(size: Int) -> [Int] {
        var a:[Int] = []
        
        (0..<size).forEach { _ in
            a.append(Int(arc4random()))
        }
        
        return a
    }

}
