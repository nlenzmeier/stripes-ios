//
//  LeaveCommentViewController.swift
//  STRIPES
//
//  Created by Nicolle on 9/19/18.
//  Copyright © 2018 Nicolle Lenzmeier. All rights reserved.
//

import UIKit

class LeaveCommentViewController: UIViewController {

    @IBOutlet weak var commentBox: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        commentBox.layer.cornerRadius = 10

        self.title = "Leave Comment"
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
