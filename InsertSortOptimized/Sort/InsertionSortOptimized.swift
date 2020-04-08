//
//  InsertionSortOptimized.swift
//  InsertSortOptimized
//
//  Created by DDragutan on 4/6/20.
//  Copyright © 2020 DDragutan. All rights reserved.
//

import Foundation

public func insertionSortOptimized<T:Comparable>(_ a: inout [T]) {
    //make garbage size 1% of original array or 1000 max
    let garbageSize = Int(max(1000.0, round(Double(a.count)*0.01)))
    let subArraySize = 500

    /*
     select an element as a pivot after every subArraySize elements
     this element will be first one in it's own subarray
     create a sorted array of pivots
     */
    var pivots:[T] = []
    while pivots.count * subArraySize < a.count {
        let index = pivots.count * subArraySize
        let el = a[index]
        let newIndex = binarySearchForNearest(to: el, in: pivots)
        pivots.insert(el, at: newIndex)
    }
    
    /*
     form array of arrays where each array contains a pivot
     this array os subarrays will be automatically sorted because pivots are sorted
     it's important for the last step when subarays will be merged into final sorted array
     */
    var aa:[[T]] = pivots.map {[$0]}

    var garbageCounter = 0, index=a.count-1
    while index >= 0 {
        
        //skip the pivot, it's already in it's own subarray
        if index % subArraySize == 0 {
            garbageCounter += 1
            index -= 1
            continue
        }

        //1. find appropriate subarray
        let el = a[index]
        var newIndex = binarySearchForNearest(to: el, in: pivots)
        let indexOfArray = (newIndex == pivots.count) ? newIndex-1 : newIndex
        
        //2. find a place for the element in the subarray
        newIndex = binarySearchForNearest(to: el, in: aa[indexOfArray])
        aa[indexOfArray].insert(el, at: newIndex)
        
        garbageCounter += 1
        /*
         to manage memory remove N last elements from the original array when needed
         */
        if garbageCounter >= garbageSize {
            a.removeLast(garbageCounter)
            garbageCounter = 0
        }
        
        index -= 1
    }


    /*
     1. remove all items from the original array
     2. add elements fom sub arrays to original array (remember subarrays already sorted when pivots where found)
     3. remove subarray to keep memory usage in check
     */
    a = Array()
    while aa.count > 0 {
        a.append(contentsOf: aa[0])
        aa.removeFirst()
    }

    #if ENABLE_PROFILING
//    a.insert(a.first!, at: a.count/2)
        if !verifyArraySorted(a) {
            Swift.print("\(#function) failed")
        }
    #endif
}

public func binarySearchForNearest<T:Comparable>(to element:T, in arrayToSearchIn: Array<T>) -> Int {
    guard arrayToSearchIn.count > 0 else {
        return 0
    }
    
    var low=0,high=arrayToSearchIn.count
    var index = low
    while low < high {

        let midIndex = low + (high - low)/2
        if arrayToSearchIn[midIndex] < element {
            low = midIndex+1
            index = low
        } else if arrayToSearchIn[midIndex] > element {
            high = midIndex
            index = high
        } else {
            index = midIndex
            break
        }

        /*
         by now space between elements is narrowed to 1 or 0
         and we can find appropriate position for element
         */
        if high - low == 0 {
            index = high
            break
        } else if high - low == 1 {
            index = element < arrayToSearchIn[low] ? low : high
            break
        }
    }
    return index
}
