//
//  EstimatedWaitTime.swift
//  STRIPES
//
//  Created by Nicolle on 9/13/18.
//  Copyright © 2018 Nicolle Lenzmeier. All rights reserved.
//

import Foundation

enum EstimatedWaitTime {
    case initial
    case fetching
    case notRunning
    case running(waitTime: Int)
    
    init(status: String, duration: Int) {
        switch status {
        case "notRunning":
            self = .notRunning
        case "running":
            self = .running(waitTime: duration)
        default:
            // if it doesn't say "running" don't trust it... 
            self = .notRunning
        }
    }
    
    init(data: Data) {
        // if we don't have json let's just exit
        guard  let json = try? JSONSerialization.jsonObject(with: data, options: []) else {
            print("The JSON could not be parsed.")
            self = .notRunning
            return
        }
        
        // if the json was not a map just exit
        guard let root = json as? [String: Any] else {
            print("The outmost leement of the parsed json was not a map.")
            self = .notRunning
            return
        }
        
        // exit if status was not a string
        guard let status = root["status"] as? String else {
            print("Status was not a string.")
            self = .notRunning
            return
        }
        
        switch status {
        case "notRunning":
            self = .notRunning
        case "running":
            // exit if we don't have the wait time
            guard let time = root["waitTime"] as? Int else {
                print("Could not find the wait time")
                self = .notRunning
                return
            }
            self = .running(waitTime: time)
        default:
            self = .notRunning
        }
    }
}

// old stuff (will delete it when everthing else works
//    var status: String
//    var waitTime: Int
//
//    init(data: Data) {
//        status = "running"
//        waitTime = 50
//
//        let json = try? JSONSerialization.jsonObject(with: data, options: [])
//
//        //NSLog("\(json)")
//
//        // validates that json has a value and then assigns it to a non-optional variable
//        if let json = json {
//            //NSLog("\(json)")
//
//            if let root = json as? [String: Any] {
//                // root is not a map you can use
//                //NSLog("\(root)")
//
//                if let status = root["status"] as? String {
//                    self.status = status
//                }
//
//                // if the value of waitTime is a number, assign it to my waitTime variable, if not (such as Boolean, or string) then throw an error message
//                if let waitTime = root["waitTime"] as? Double {
//                    //NSLog("Found wait time: \(waitTime)")
//                    self.waitTime = Int(waitTime)
//                } else {
//                    NSLog("could not find wait time or it wasn't a number")
//                }
//
//            } else {
//                print("The outmost element of the parsed json was not a map.")
//            }
//        } else {
//            print("The JSON could not be parsed.")
//        }
//
//    }

