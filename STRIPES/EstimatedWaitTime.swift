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
            print("The outmost element of the parsed json was not a map.")
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
