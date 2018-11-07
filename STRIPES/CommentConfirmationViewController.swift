//
//  CommentConfirmationViewController.swift
//  STRIPES
//
//  Created by Nicolle on 11/5/18.
//  Copyright © 2018 Nicolle Lenzmeier. All rights reserved.
//

import UIKit

class CommentConfirmationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.title = "Comment Confirmation"
        
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
