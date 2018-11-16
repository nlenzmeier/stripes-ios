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
    
    
    
    @IBAction func sendComment() {
        NSLog("I hit submit!")
        
        if(commentBox.text.isEmpty) {
            NSLog("Comment box is empty.")
            displayErrorAlert()
        } else {
            
            var form : [String : String] = [:]
            
            if let comment = commentBox.text {
                form["comment"] = comment
            }
            
            let jsonData = try! JSONSerialization.data(withJSONObject: form, options: [])
            //let jsonString = String(data: jsonData, encoding: .utf8)!       // Sarah and/or Jeremy: this is your jsonObject
            
            // create POST request
            let url = URL(string: "http://104.248.54.97/api/LeaveComment")!
            var request = URLRequest(url: url)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            
            // insert json data to the request
            request.httpBody = jsonData
            
            let session = URLSession.shared
            session.dataTask(with: request) { (data, response, error ) in
                if let response = response {
                    print(response)
                }
                if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: [])
                        print(json)
                    } catch {
                        print(error)
                    }
                }
            }.resume()
            
            performSegue(withIdentifier: "Comment Confirmation", sender: self)
        }
    }
    
    // comment box cannot be empty error
    @IBAction func displayErrorAlert() {
        let alertController = UIAlertController(title: "Error",
                                                message: "Comment box cannot be empty.",
                                                preferredStyle: UIAlertController.Style.alert)
        
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        guard   // guard means "make sure these items exist"
            let userInfo = notification.userInfo,
            let frameEnd = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        NSLog("frameEnd: \(frameEnd)")
        
        commentBox.contentInset.bottom = frameEnd.height
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self) // prevents crashes if the keyboard is activated again after someone leaves the page
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Leave Comment"
        // Do any additional setup after loading the view.
        
        // calling for keyboard
        let center = NotificationCenter.default // sets a variable called “center” to the “default” notification center in the app, which is what iOS will use to communicate the needed information to you
        center.addObserver(self,
                           selector: #selector(keyboardWillShow),
                           name: UIResponder.keyboardWillShowNotification,
                           object: nil)
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
