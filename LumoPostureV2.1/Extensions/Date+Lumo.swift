//
//  Date+Conversion.swift
//  LumoPostureV2.0
//
//  Created by Emil Selin on 4/5/18.
//  Copyright © 2018 com. All rights reserved.
//

import Foundation

extension Date {
    func toLocal() -> Date {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "GMT")!
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: self)
        return Calendar.current.date(from: components)!
    }
    
    func toServer() -> Date {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "GMT")!
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: self)
        return calendar.date(from: components)!
    }
}
