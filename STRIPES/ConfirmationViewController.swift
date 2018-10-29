//
//  ConfirmationViewController.swift
//  STRIPES
//
//  Created by Nicolle on 10/29/18.
//  Copyright © 2018 Nicolle Lenzmeier. All rights reserved.
//

import UIKit

class ConfirmationViewController: UIViewController {

    
    @IBAction func cancelRideCall() {
        // Alert to call STRIPES
        UIApplication.shared.open(URL(string: "tel:573-442-9672")!, options: [:], completionHandler: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Confirmation"
        // Do any additional setup after loading the view.
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
