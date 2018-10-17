//
//  EstimatedWaitTime.swift
//  STRIPES
//
//  Created by Nicolle on 9/13/18.
//  Copyright © 2018 Nicolle Lenzmeier. All rights reserved.
//

import Foundation

struct EstimatedWaitTime {
    var status: String
    var waitTime: Int
    
    init(data: Data) {
        status = "running"
        waitTime = 50
        
        let json = try? JSONSerialization.jsonObject(with: data, options: [])
        
        //NSLog("\(json)")
        
        // validates that json has a value and then assigns it to a non-optional variable
        if let json = json {
            //NSLog("\(json)")
            
            if let root = json as? [String: Any] {
                // root is not a map you can use
                //NSLog("\(root)")
                
                if let status = root["status"] as? String {
                    self.status = status
                }
                
                // if the value of waitTime is a number, assign it to my waitTime variable, if not (such as Boolean, or string) then throw an error message
                if let waitTime = root["waitTime"] as? Double {
                    //NSLog("Found wait time: \(waitTime)")
                    self.waitTime = Int(waitTime)
                } else {
                    NSLog("could not find wait time or it wasn't a number")
                }
                
            } else {
                print("The outmost element of the parsed json was not a map.")
            }
        } else {
            print("The JSON could not be parsed.")
        }
        
    }
}
