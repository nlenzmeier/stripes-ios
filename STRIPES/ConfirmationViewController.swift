//
//  ConfirmationViewController.swift
//  STRIPES
//
//  Created by Nicolle on 10/29/18.
//  Copyright © 2018 Nicolle Lenzmeier. All rights reserved.
//

import UIKit

class ConfirmationViewController: UIViewController {

    @IBOutlet weak var cancelButton: UIButton!
    
    @IBAction func cancelRideCall() {
        // Alert to call STRIPES
        
        #if targetEnvironment(simulator)
        
        print("I would be calling STRIPES right now on a device")
        
        #else
        
        UIApplication.shared.open(URL(string: "tel:573-442-9672")!, options: [:], completionHandler: nil)
        
        #endif
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Confirmation"
        // Do any additional setup after loading the view.
        
        cancelButton.layer.cornerRadius = 20
        
        // this flashes "back" before presenting "STRIPES" ... just something that we have to put up with
        navigationController?.removeAllMiddleViewControllers()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

// Helper function inserted by Swift 4.2 migrator.
//fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
//    print("I'm in the new function!")
//    return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
//}
