//
//  WaitTimeViewController.swift
//  STRIPES
//
//  Created by Nicolle on 9/10/18.
//  Copyright © 2018 Nicolle Lenzmeier. All rights reserved.
//

import UIKit

class WaitTimeViewController: UIViewController {
    
    @IBOutlet var waitTime: UILabel!
    
    var minutes: Int
    
    init(using minutes: Int) {
        self.minutes = minutes
        super.init(nibName: nil, bundle: nil)
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.waitTime.text = minutes.readableWaitTime()
        
        // Do any additional setup after loading the view.
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
