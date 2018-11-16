//
//  ViewController.swift
//  STRIPES
//
//  Created by Nicolle on 8/9/18.
//  Copyright © 2018 Nicolle Lenzmeier. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
 
    @IBOutlet weak var roundedcornerButton: UIButton!
    
    @IBOutlet weak var timeDisplayView: UIView!
    
    // creating outlet for STRIPES:
    @IBOutlet weak var TimeDisplay: UILabel!
    
    weak var waitingVc: UIViewController?
    weak var waitTimeVc: UIViewController?
    weak var errorVc: UIViewController?
    
    var rideStatus: RideStatus? 
    
    deinit {
        // de-register for any notifications
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // round the corners for the continue button
        roundedcornerButton.layer.cornerRadius = 20
        
        // loads the view controller
        let waitingVc = WaitingViewController()
        
        // add view controller to parent view controller
        addChild(waitingVc)
        waitingVc.didMove(toParent: self)
        
        // add view to parent view
        let waitingView = waitingVc.view!   // similar to dragging out a view from the xcode view library panel
        waitingView.translatesAutoresizingMaskIntoConstraints = false   // activate AutoLayout for the view
        timeDisplayView.addSubview(waitingView)
        
        let leadingConstraint = timeDisplayView.leadingAnchor.constraint(equalTo: waitingView.leadingAnchor)
        leadingConstraint.isActive = true
        
        let topConstraint = timeDisplayView.topAnchor.constraint(equalTo: waitingView.topAnchor)
        topConstraint.isActive = true
        
        let trailingConstraint = timeDisplayView.trailingAnchor.constraint(equalTo: waitingView.trailingAnchor)
        trailingConstraint.isActive = true
        
        let bottomConstraint = timeDisplayView.bottomAnchor.constraint(equalTo: waitingView.bottomAnchor)
        bottomConstraint.isActive = true
        
        let center = NotificationCenter.default
        center.addObserver(forName: RideStatus.rideStatusChange,
                           object: nil,
                           queue: OperationQueue.main) { notification in
                        self.reconfigureUI()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        print("destination: \(segue.destination)")
        if let navVc = segue.destination as? UINavigationController {
            navVc.navigationBar.barStyle = .black
            
            print(String(describing: navVc.topViewController))
            
            if let optVc = navVc.topViewController as? OptionScreenViewController {
                
                // because rideStatus is an optional, but we NEED it for OptionScreenViewController
                if let rideStatus = rideStatus {
                    optVc.acceptData(rideStatus: rideStatus)
                }
                
            }
        }
    }
    
    
    func reconfigureUI() {
        
        if let rideStatus = rideStatus {
            switch rideStatus.state {
            case .initial:
                let message = "Loading..."
                let errorVc = ErrorViewController(using: message)
                self.errorVc = errorVc
            case .fetching:
                let message = "Loading..."
                let errorVc = ErrorViewController(using: message)
                self.errorVc = errorVc
            case .notRunning:
                let message = "STRIPES is not running at this time."
                let errorVc = ErrorViewController(using: message)
                self.errorVc = errorVc
                transitionFromWaiting(to: errorVc)
            case .running(let waitTime):
                let waitTimeVc = WaitTimeViewController(using: Int(waitTime))
                self.waitTimeVc = waitTimeVc
                transitionFromWaiting(to: waitTimeVc)
            }
        }
    }
    
    
    // this function replaces one view controller (and its associated views) with another view controller (and its associated views)
    func transitionFromWaiting(to viewController: UIViewController) {
        // Part A: Remove Waiting View and View Controller
        
        // step 1: prepare for waiting view removal
        waitingVc?.willMove(toParent: nil)
        // step 2: remove waiting view
        waitingVc?.view.removeFromSuperview()
        // step 3: remove waiting view controller
        waitingVc?.removeFromParent()
        
        // Part B: Add Wait Time view and View Controller
        // (NOTE: This code is idental to how we added the first view controller)
        
        
        // add view controller to parent view controller
        addChild(viewController)
        viewController.didMove(toParent: self)
        
        // add view to parent view
        let waitTimeView = viewController.view!   // similar to dragging out a view from the xcode view library panel
        waitTimeView.translatesAutoresizingMaskIntoConstraints = false   // activate AutoLayout for the view
        timeDisplayView.addSubview(waitTimeView)
        
        let leadingConstraint = timeDisplayView.leadingAnchor.constraint(equalTo: waitTimeView.leadingAnchor)
        leadingConstraint.isActive = true
        
        let topConstraint = timeDisplayView.topAnchor.constraint(equalTo: waitTimeView.topAnchor)
        topConstraint.isActive = true
        
        let trailingConstraint = timeDisplayView.trailingAnchor.constraint(equalTo: waitTimeView.trailingAnchor)
        trailingConstraint.isActive = true
        
        let bottomConstraint = timeDisplayView.bottomAnchor.constraint(equalTo: waitTimeView.bottomAnchor)
        bottomConstraint.isActive = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

