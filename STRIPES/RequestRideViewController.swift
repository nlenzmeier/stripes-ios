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
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    
    let locationManager = CLLocationManager()
    let geocoder = CLGeocoder()
    
    @IBAction func submitForm() {
        NSLog("I hit submit!")
 
        // TODO: think of a way to better organize this because this will always be the first error message when an empty form is submitted and doesn't feel right
        
        if let cellPhoneNumber = self.cellPhoneNumber.text {
            // if there is a 10 or 11 returned from cellPhoneNumber.digitCount() then do this... 
            if [10, 11].contains((cellPhoneNumber.digitCount())) {
                NSLog("We're valid!")
            } else {
                displayPhoneErrorAlert()
            }
        }
        
        if let homeAddress = self.homeAddress.text, let pickUpLocation = self.pickUpLocation.text {
            let homeArray = homeAddress.components(separatedBy: ",")
            let pickUpArray = pickUpLocation.components(separatedBy: ",")
            
            print(homeArray)
            print(pickUpArray)
            
            // doesn't make sense to have the pick up the same as the dropoff
            // since we only pickup/drop off in CoMo we shouldn't have any matching addresses
            if homeArray.first == pickUpArray.first {
                    displaySameAddressAlert()
            }
            
        }
        
        if (self.firstName.text?.isEmpty)! {
            NSLog("Form is invalid. Missing first name.")
            displayNameErrorAlert()
        } else if (self.homeAddress.text?.isEmpty)! {
            NSLog("Form is invalid. Missing home address.")
            displayHomeErrorAlert()
        }else if (self.cellPhoneNumber.text?.isEmpty)! {
            NSLog("Form is invalid. Missing cell phone number.")
            displayPhoneErrorAlert()
        } else if (self.pickUpLocation.text?.isEmpty)! {
            NSLog("Form is invalid. Missing pickup locaiton.")
            displayPickupErrorAlert()
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
            
            if let passengers = self.passengers.titleForSegment(at: passengers.selectedSegmentIndex) {
                form["passengers"] = passengers
            }
            
            if let dropoffs = self.dropoffs.titleForSegment(at: dropoffs.selectedSegmentIndex) {
                form["dropoffs"] = dropoffs
            }
            
            if let pickUpLocation = self.pickUpLocation.text {
                form["pickUpLocation"] = pickUpLocation
            }
            
            guard let jsonData = try? JSONSerialization.data(withJSONObject: form, options: []) else {
                return
            }
//            let jsonString = String(data: jsonData, encoding: .utf8)!       // Sarah and/or Jeremy: this is your jsonObject
            //print("jsonString is: \n" + jsonString)
            
            // sending request!
            // create post request
            let url = URL(string: "http://104.248.54.97/api/Rides")!
            var request = URLRequest(url: url)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            
            // insert json data to the request
            request.httpBody = jsonData
            
            let session = URLSession.shared
            session.dataTask(with: request) { (data, response, error) in
                if let response = response  {
                    print("Here is the reponse:")
                    print(response)
                    print("End reponse")
                }
                if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: [])
                        print("Here is the json:")
                        print(json)
                        print("End json")
                    } catch {
                        print("Here is the error:")
                        print(error)
                        print("End error:")

                    }
                }
            }.resume()
            
            NSLog("Form is completed!")
            performSegue(withIdentifier: "Confirmation", sender: self)
        }
        
        
    }
    
    // error message that you must have two different addresses
    func displaySameAddressAlert() {
        let alertController = UIAlertController(title: "Error",
                                                message: "Your pickup location cannot be the same as your home address.",
                                                preferredStyle: UIAlertController.Style.alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    
    // error message that you must have a phone number between 10 and 11
    func displayPhoneErrorAlert() {
        cellPhoneNumber.becomeFirstResponder()
        
        let alertController = UIAlertController(title: "Error",
                                                message: "You must have a phone number with 10 to 11 numbers.",
                                                preferredStyle: UIAlertController.Style.alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    // displaying generic error, but clicking into the first name field
    func displayNameErrorAlert() {
        firstName.becomeFirstResponder()
        
        let alertController = UIAlertController(title: "Error",
                                                message: "You must answer all fields to request a ride.",
                                                preferredStyle: UIAlertController.Style.alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    // displaying generic error, but clicking into the home address field
    func displayHomeErrorAlert() {
        homeAddress.becomeFirstResponder()
        
        let alertController = UIAlertController(title: "Error",
                                                message: "You must answer all fields to request a ride.",
                                                preferredStyle: UIAlertController.Style.alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    // displaying generic error, but clicking into the pick up location field
    func displayPickupErrorAlert() {
        pickUpLocation.becomeFirstResponder()
        
        let alertController = UIAlertController(title: "Error",
                                                message: "You must answer all fields to request a ride.",
                                                preferredStyle: UIAlertController.Style.alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        NSLog("I made it to didUpdateLocations!")           // Yay! We're here!
        NSLog("Location: \(locationManager.location ?? CLLocation())")      // same as locations, but this is an optional
        NSLog("LOCATIONS: \(locations)")                    // this is not. We use this way.

        // to grab the single location from our array of one element
        if let location = locations.first {
            
            geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                NSLog("Placemarks: \(String(describing: placemarks))")
                
                if let placemark = placemarks?.first {
                    NSLog("Placemark: \(String(describing: placemark))")        // now we have a readable location!
                    
                    // array of elements we will want for the pickup location
                    let locationElements = [placemark.name, placemark.locality, placemark.administrativeArea, placemark.postalCode]
                    NSLog("location elements: \(locationElements)")
                    // but this is of all optional values. We don't want that, so...
                    
                    let compactLocationElements = locationElements.compactMap { $0 }
                    // compactMap returns the non-nil results within the array locationElements
                    // $0 means what you name the first parameter, you could also do it this way:
                    // let compactLocationElements = locationElements.compactMap { str in str }
                    // { ... } is the anonymous function
                    // meaning that for each element in locationElements, the closure ( { ... } ) will be called
                    // first str is the parameter to that function
                    // second str is the return result from the function
                    // so let's say zip is nil. we can still get the rest of the address even though we are missing an element
                    NSLog("compact map location elements: \(compactLocationElements)")
                    
                    let result = compactLocationElements.joined(separator: ", ")
                    NSLog("result: \(result)")
                    
                    self.removeWaitingWheel()
                    self.pickUpLocation.text = result
                }
            }
        }
    }
    
    func spinWaitingWheel() {
        spinner.isHidden = false
    }
    
    func removeWaitingWheel() {
        spinner.isHidden = true
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
            beginLocationFinding()
        }
    }
    
    // since we want the user to only have to press the button ONCE when the app runs the first time, we need to accommodate that
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
            beginLocationFinding()
        }
        
    }
    
    func beginLocationFinding() {
        spinWaitingWheel()
        locationManager.requestLocation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        NSLog("UserInfo: \(String(describing: notification.userInfo))")
        
        guard   // guard means "make sure these items exist"
            let userInfo = notification.userInfo,
            let frameEnd = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        NSLog("frameEnd: \(frameEnd)")
        
        scrollView.contentInset.bottom = frameEnd.height
        // scrollView.contentInset.bottom = 500
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self) // prevents crashes if the keyboard is activated again after someone leaves the page 
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.contentInsetAdjustmentBehavior = .never
        
        self.title = "Request Ride"
        // Do any additional setup after loading the view.
        
        // round corners of Find My Location button 
        locationButton.layer.cornerRadius = 15
        
        // let locationManager know that we will handle responses
        // DO NOT SET HERE! It will automatically fetch and display location as soon as "Request Ride" is selected
        // locationManager.delegate = self
        
        /*
         if we had more time, and perhaps more developers, we could ask the first time and it would be slow
         but the second and so forth times we would actually cache the current location from app's startup BECAUSE they already granted
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
                           name: UIResponder.keyboardWillShowNotification,
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
