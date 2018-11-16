//
//  RideStatus.swift
//  STRIPES
//
//  Created by Nicolle on 11/14/18.
//  Copyright © 2018 Nicolle Lenzmeier. All rights reserved.
//

import Foundation

class RideStatus {
    var state = EstimatedWaitTime.initial {
        willSet {
            NSLog("I'm about to be changed.")
        }
        didSet {
            NSLog("I've been changed.")
            
            // let those that listen to me know of my achievement! AKA: broadcast notification
            let center = NotificationCenter.default
            center.post(name: RideStatus.rideStatusChange, object: nil)
        }
    }
    
    var dataTask: URLSessionDataTask?
    
    // define application unique notification name. This must be different from every other notification in the app
    static let rideStatusChange = Notification.Name("rideStatusChange")
    
    func retrieveRideStatus() {
        let url = URL(string: "http://104.248.54.97/api/WaitTime")!
        //let url = URL(string: "http://127.0.0.1:3000/time")!
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url) { data, urlResponse, error in
            if let data = data, let string = String(data: data, encoding: .utf8) {
                print(string)
                
                self.state = EstimatedWaitTime.init(data: data)            
            }
        }
        self.dataTask = dataTask
        dataTask.resume()
    }
    
}
