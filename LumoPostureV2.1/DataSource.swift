//
//  DataSource.swift
//  LumoPostureV2.1
//
//  Created by Emil Selin on 4/15/18.
//  Copyright © 2018 com. All rights reserved.
//

import Foundation

class DataSource {
    private let dataLock = DispatchSemaphore(value: 1)
    var lastUpdated: Date = Date(timeIntervalSince1970: 86400)
    var totalTime: Float = 0
    var postureTime: Float = 0
    var posture: [Float] = [Float]()
    var first: Date?
    
    func lockData() {
        dataLock.wait()
    }
    
    func unlockData() {
        dataLock.signal()
    }
    
    func addDates(start: Date, end: Date) {
        // initialize first date of data
        if first == nil {
            first = start
        }
        
        // number of days to add to array
        var size = 0
        if posture.isEmpty {
            size = Calendar.current.dateComponents([.day], from: start, to: end).day! + 1
        } else {
            size = Calendar.current.dateComponents([.day], from: dateFrom(index: posture.count-1), to: end).day!
        }
        
        // add days to array
        if size > 0 {
            posture.append(contentsOf: Array(repeating: 0, count: size))
        }
    }
    
    // add data for date
    func addValue(date: Date, good: Float, bad: Float) {
        posture[indexFrom(date: date)] = percent(part: good, whole: good+bad)
        postureTime += good
        totalTime += (good+bad)
    }
    
    // get date from index
    func dateFrom(index: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: index, to: first!)!
    }
    
    // get index from date
    func indexFrom(date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: first!, to: date).day!
    }
    
    // get today's posture
    func getToday() -> Float {
        return posture[indexFrom(date: Date())]
    }
    
    // calculate percentage
    private func percent(part: Float, whole: Float) -> Float {
        if whole == 0 {
            return 0
        }
        return part/whole
    }
    
    // reset data source
    func reset() {
        lastUpdated = Date(timeIntervalSince1970: 86400)
        totalTime = 0
        postureTime = 0
        posture = [Float]()
        first = nil
    }
}

