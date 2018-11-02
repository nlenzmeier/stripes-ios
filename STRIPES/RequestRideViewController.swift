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
    
    @IBOutlet weak var pickUpLocation: UITextField!
    @IBOutlet weak var cellPhoneNumber: UITextField!
    @IBOutlet weak var homeAddress: UITextField!
    @IBOutlet weak var firstName: UITextField!
    
    @IBOutlet weak var passengers: UISegmentedControl!
    @IBOutlet weak var dropoffs: UISegmentedControl!
    
    let locationManager = CLLocationManager()
    let geocoder = CLGeocoder()
    
    @IBAction func submitForm() {
        NSLog("I hit submit!")
        
        /*
        NSLog("name: \(self.firstName.text)")
        NSLog("home address: \(self.homeAddress.text)")
        NSLog("cell phone number: \(self.cellPhoneNumber.text)")
        NSLog("pick up location: \(self.pickUpLocation.text)")
        NSLog("passengers: \(self.passengers.titleForSegment(at: passengers.selectedSegmentIndex))")
        NSLog("dropoffs: \(self.dropoffs.titleForSegment(at: dropoffs.selectedSegmentIndex))")
        */
 
        // TODO: think of a way to better organize this because this will always be the first error message when an empty form is submitted and doesn't feel right
        if let cellPhoneNumber = self.cellPhoneNumber.text {
            let digits: Set<Character> = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]
            
            var counter = 0                 // counts valid characters in the cell phone number string
            for num in cellPhoneNumber {
                print("Letter: \(num)")
                
                if digits.contains(num) {
                    counter += 1
                }
            }
            
            print("The number of valid digits is: \(counter)")
            
            if (counter == 10 || counter == 11) {
                NSLog("We're valid!")
            } else {
                displayPhoneErrorAlert()
            }
        }
        
        if (self.firstName.text?.isEmpty)! {
            NSLog("Form is invalid. Missing first name.")
            displayErrorAlert()
        } else if (self.homeAddress.text?.isEmpty)! {
            NSLog("Form is invalid. Missing home address.")
            displayErrorAlert()
        }else if (self.cellPhoneNumber.text?.isEmpty)! {
            NSLog("Form is invalid. Missing cell phone number.")
            displayErrorAlert()
        } else if (self.pickUpLocation.text?.isEmpty)! {
            NSLog("Form is invalid. Missing pickup locaiton.")
            displayErrorAlert()
        } else {
            // passengers and droppoffs will never be empty
            
            var form : [String: Any] = [:]
            
            if let firstName = self.firstName.text {
                form["firstName"] = firstName
            }
            
            if let homeAddress = self.homeAddress.text {
                form["homeAddress"] = homeAddress
            }
            
            if let cellPhoneNumber = self.cellPhoneNumber.text {
                    form["cellPhoneNumber"] = cellPhoneNumber
            }
            
            if let pickUpLocation = self.pickUpLocation.text {
                form["pickUpLocation"] = pickUpLocation
            }
            
            if let passengers = self.passengers.titleForSegment(at: passengers.selectedSegmentIndex) {
                form["passengers"] = passengers
            }
            
            if let dropoffs = self.dropoffs.titleForSegment(at: dropoffs.selectedSegmentIndex) {
                form["dropoffs"] = dropoffs
            }
            
            let jsonData = try! JSONSerialization.data(withJSONObject: form, options: [])
            let jsonString = String(data: jsonData, encoding: .utf8)!
            print("jsonString is: \n")
            print(jsonString)
            
            
            NSLog("Form is completed!")
            performSegue(withIdentifier: "Confirmation", sender: self)
        }
        
        
    }
    
    // error message that you must have a phone number between 10 and 11
    @IBAction func displayPhoneErrorAlert() {
        let alertController = UIAlertController(title: "Error",
                                                message: "You must have a phone number with 10 to 11 numbers.",
                                                preferredStyle: UIAlertControllerStyle.alert)
        
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    // generic error message for everything else
    @IBAction func displayErrorAlert() {
        let alertController = UIAlertController(title: "Error",
                                                message: "You must answer all fields to request a ride.",
                                                preferredStyle: UIAlertControllerStyle.alert)
        
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        NSLog("I made it to didUpdateLocations!")           // Yay! We're here!
        NSLog("Location: \(locationManager.location)")      // same as locations, but this is an optional
        NSLog("LOCATIONS: \(locations)")                    // this is not. We use this way.

        // to grab the single location from our arrya of one element
        if let location = locations.first {
            geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                NSLog("Placemarks: \(placemarks)")
                
                if let placemark = placemarks?.first {
                    NSLog("Placemark: \(placemark)")        // now we have a readable location!
                    
                    // array of elements we will want for the pickup location
                    let locationElements = [placemark.name, placemark.locality, placemark.administrativeArea, placemark.postalCode]
                    NSLog("location elements: \(locationElements)")
                    // but this is of all optional values. We don't want that, so...
                    
                    let compactLocationElements = locationElements.compactMap { $0 }
                    // compactMap returns the non-nil results within the array locationElements
                    // $0 means what you names the first parameter, you could also do it this way:
                    // let compactLocationElements = locationElements.compactMap { str in str }
                    // { ... } is the anonymous function
                    // meaning that for each element in locationElements, the closure ( { ... } ) will be called
                    // first str is the parameter to that function
                    // seond str is the return result from the funtion
                    // so let's say zip is nil. we can still get the rest of the address even though we are missing an element
                    NSLog("compact map location elements: \(compactLocationElements)")
                    
                    let result = compactLocationElements.joined(separator: ", ")
                    NSLog("result: \(result)")
                    
                    self.pickUpLocation.text = result
                }
            }
        }
    }
    
    // since our location grabbing service can fail, we must account for it.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        NSLog("I failed!")                                  // Boooo. This is bad.
    }
    
    @IBAction func findMyLocation() {
        
        locationManager.delegate = self
        
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
    
    // since we want the user to only have to press the button ONCE when the app runs the first time, we need to accommodate  that
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        NSLog("I made is to didchangeAuthorization!")
        
        switch status {
        case .notDetermined:
            NSLog("I'm in notDetermined 2!")
        case .restricted:
            NSLog("I'm in restricted 2!")
        case .denied:
            NSLog("I'm in denied 2!")
        case .authorizedAlways:
            NSLog("I'm in authorizedAlways 2!")
        case .authorizedWhenInUse:
            NSLog("I'm in authorizedWhenInUse 2!")
            
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
        locationButton.layer.cornerRadius = 15
        
        // let locationManager know that we will handle responses
        // DO NOT SET HERE! It will automatically fetch and display location as soon as "Request Ride" is selected
        // locationManager.delegate = self
        
        /*
         if we had more time, and perhaps more developers, we could ask the first time and it would be slow
         but the second and so forth times we would actually cache the current location from app's startup BECAUSE they alread granted
         us access to their location
         and IF the form is touched between X number of secods (for good accuracy), we'd just use the cached value for the form,
         making the button APPEAR to be faster than it can actually ever be
         
         but for now, this will have to do for accuracy (and time)
         
         "the elevators are too slow"
        */
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        
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
