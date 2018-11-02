//
//  UINavigationController+Extensions.swift
//  STRIPES
//
//  Created by Nicolle on 10/31/18.
//  Copyright © 2018 Nicolle Lenzmeier. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationController {
    
    // remove all middle view controllers, leaving only the first and the last
    func removeAllMiddleViewControllers() {
        // this array is in order. Element 0 is the root view controller (the first one).
        // attempt to get the first and last elements. (make sure the count >= 2 or else first and last will be the same, would isn't what we want)
        if viewControllers.count >= 2,
            let first = viewControllers.first,
            let last = viewControllers.last {
            
            // now create a new array of  view controllers
            let newControllers = [first, last]
            
            // finally assign the array back to the navigation controller
            viewControllers = newControllers
        }
    }
}
