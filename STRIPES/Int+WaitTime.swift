//
//  Int+WaitTime.swift
//  STRIPES
//
//  Created by Nicolle on 9/10/18.
//  Copyright © 2018 Nicolle Lenzmeier. All rights reserved.
//

import Foundation

extension Int {
    func readableWaitTime() -> String {
        let gregorian = Calendar(identifier: .gregorian)
        let components = DateComponents(calendar: gregorian,
                                        timeZone: nil,
                                        era: nil,
                                        year: nil,
                                        month: nil,
                                        day: nil,
                                        hour: nil,
                                        minute: self,
                                        second: nil,
                                        nanosecond: nil,
                                        weekday: nil,
                                        weekdayOrdinal: nil,
                                        quarter: nil,
                                        weekOfMonth: nil,
                                        weekOfYear: nil,
                                        yearForWeekOfYear: nil)
        
        let formatter = DateComponentsFormatter()
        formatter.includesApproximationPhrase = false
        formatter.includesTimeRemainingPhrase = false
        formatter.allowedUnits = [.minute, .hour]
        
        formatter.unitsStyle = .full
        print(formatter.string(from: components)!)
        
        let conversion = formatter.string(from: components)!
        print(conversion)
        
        return conversion
    }
}
