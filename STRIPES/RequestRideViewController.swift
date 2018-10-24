//
//  RequestRideViewController.swift
//  STRIPES
//
//  Created by Nicolle on 9/18/18.
//  Copyright © 2018 Nicolle Lenzmeier. All rights reserved.
//

import UIKit
import CoreLocation

// CLLocationManagerDelegate says RequestRideViewController will be a location manager delegate
class RequestRideViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet var firstNameTextField: UITextField!
    
    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet weak var locationButton: UIButton!
    
    let locationManager = CLLocationManager()
    let geocoder = CLGeocoder()
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        NSLog("I made it to didUpdateLocations!")           // Yay! We're here!
        NSLog("Location: \(locationManager.location)")      // same as locations, but this is an optional
        NSLog("LOCATIONS: \(locations)")                    // this is not. We use this way.

        // to grab the single location from our arrya of one element
        if let location = locations.first {
            geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                NSLog("Placemarks: \(placemarks)")
                
                if let placemark = placemarks?.first {
                    NSLog("Placemark: \(placemark)")        // now we have a reabable location! 
                }
            }
        }
    }
    
    // since our location grabbing service can fail, we must account for it.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        NSLog("I failed!")                                  // Boooo. This is bad.
    }
    
    @IBAction func findMyLocation() {
        NSLog("I am in findMyLocation!")
        
        let status = CLLocationManager.authorizationStatus()
        NSLog("Status: \(status.rawValue)")
        
        
        // status changes on if they "Allow" or "Deny" location services
        switch status {
        case .notDetermined:
            NSLog("I'm in notDetermined!")
            
            locationManager.requestWhenInUseAuthorization()     // asking user for permission to use location services while app is in use only
            
        case .restricted:
            NSLog("I'm in restricted!")
        case .denied:
            NSLog("I'm in denied!")
        case .authorizedAlways:
            NSLog("I'm in authorizedAlways!")       // shouldn't need this one 
        case .authorizedWhenInUse:
            // is access was granted, we should land here
            
            NSLog("I'm in authorizedWhenInUse!")    // this one should be the one that hits
            
            locationManager.requestLocation()
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        NSLog("UserInfo: \(notification.userInfo)")
        
        guard   // guard means "make sure these items exist"
            let userInfo = notification.userInfo,
            let frameEnd = userInfo[UIKeyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        NSLog("frameEnd: \(frameEnd)")
        
        scrollView.contentInset.bottom = frameEnd.height
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self) // prevents crashes if the keyboard is activated again after someone leaves the page 
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.title = "Request Ride"
        // Do any additional setup after loading the view.
        
        // round corners of Find My Location button 
        locationButton.layer.cornerRadius = 20
        
        // let locationManager know that we will handle responses
        locationManager.delegate = self 
        
        let center = NotificationCenter.default // sets a variable called “center” to the “default” notification center in the app, which is what iOS will use to communicate the needed information to you
        center.addObserver(self,
                           selector: #selector(keyboardWillShow),
                           name: NSNotification.Name.UIKeyboardWillShow,
                           object: nil)
        /*
         So the way you use a NotificationCenter object is you “observe” broadcasts. It’s like tuning into a cable station.
        Whenever the keyboard is about to show, iOS will broadcast this: “NSNotification.Name.UIKeyboardWillShow”
        … whether anyone is listening or not.
        So that’s why the method name is called “addObserver”. You are observing notification broadcasts.
        In this case, you are saying: “Add observer self (this instance of this class).”
        And call a function named “keyboardWillShow”. You could have called it booger, and if you put #selector(booger), it would have worked just as well, though it would have been less readable…
        The name is the name of the broadcast. Each type of broadcast has a unique name. This one was created by Apple and is in the documentation.
         And the final parameter means that you don’t care WHICH object broadcast it. If you are using the NotifcationCenter for your own broadcasts (which you can), you can decide to listen to broadcasts from only one place.
         */
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
