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
    
    var dataTask: URLSessionDataTask?
    
    var estimatedWaitTime: EstimatedWaitTime?
    
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
        
        // let url = URL(string: "http://104.248.54.97/api/Health")!
        //let url = URL(string: "http://127.0.0.1:3000/time")!
        // let url = URL(string: "http://127.0.0.1:3000/notRunning")!
        let url = URL(string: "http://104.248.54.97/api/WaitTime")!
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url) { data, urlResponse, error in
            if let data = data, let string = String(data: data, encoding: .utf8) {
                print(string)
                
                self.estimatedWaitTime = EstimatedWaitTime(data: data)
                
                // Because we can only perform UI operations on the main thread
                DispatchQueue.main.async {
                    self.reconfigureUI()
                }
                
                // print("status: \(self.estimatedWaitTime?.status)")
                // print("waitTime: \(self.estimatedWaitTime?.waitTime)")

            }
        }
        
        dataTask.resume()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        NSLog("*** MADE IT HERE ***")
        NSLog("EWT: \(String(describing: estimatedWaitTime))")
        
        print("destination: \(segue.destination)")
        if let navVc = segue.destination as? UINavigationController {
            navVc.navigationBar.barStyle = .black
            
            NSLog("As Kevin Rudolf would say... I made it!")
            print(String(describing: navVc.topViewController))
            
            if let optVc = navVc.topViewController as? OptionScreenViewController {
                NSLog("As Kevin Rudolf would say... I made it X 2!")
                
                // because estimatedWaitTime is an optional, but we NEED it for OptionScreenViewController
                if let estimatedWaitTime = estimatedWaitTime {
                    optVc.acceptData(estimatedWaitTime: estimatedWaitTime)
                }
                
            }
        }
        //acceptData(estimatedWaitTime: estimatedWaitTime)
    }
    
    func reconfigureUI() {
        
        if let estimatedWaitTime = estimatedWaitTime {
            switch estimatedWaitTime {
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

