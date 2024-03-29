//
//  OptionScreenViewController.swift
//  STRIPES
//
//  Created by Nicolle on 9/10/18.
//  Copyright © 2018 Nicolle Lenzmeier. All rights reserved.
//

import UIKit

class OptionScreenViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    // var estimatedWaitTime: EstimatedWaitTime?
    
    var rideStatus: RideStatus?
    
    deinit {
        // de-register for any notifications
        NotificationCenter.default.removeObserver(self)
    }
    
    func acceptData(rideStatus: RideStatus) {
        self.rideStatus = rideStatus
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("I just clicked cell \(indexPath)")
        
        if indexPath == [0,0] {
            performSegue(withIdentifier: "Request Ride", sender: nil)
        } else if indexPath == [0,1] {
            performSegue(withIdentifier: "Leave Comment", sender: nil)
        } else if indexPath == [0,2] {
            performSegue(withIdentifier: "Lost and Found", sender: nil)
        } else if indexPath == [0,3] {
            // Alert to call STRIPES
            UIApplication.shared.open(URL(string: "tel:573-442-9672")!, options: [:], completionHandler: nil)
            deselectRows(in: tableView)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        deselectRows(in: tableView)
    }
    
    
    
    let options = ["Request Ride",
                   "Leave Comment",
                   "Lost and Found",
                   "Cancel Ride"]
    
    let images = ["grayStripesCar30x30",
                  "comment",
                  "lost&found30X30",
                  "cancel"]
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        
        // checking for the "cancel ride" option since that does not have a disclosure indicator
        if indexPath.row == 3 {
            
            cell.textLabel?.text = options[indexPath.row]
            cell.imageView?.image = UIImage(named: self.images[indexPath.row])
            cell.textLabel?.font = UIFont.systemFont(ofSize: 18.0)
        } else {
            
            if indexPath.row == 0 {
                
                if let rideStatus = rideStatus {
                    switch rideStatus.state {
                    case .initial:
                        print("We don't need to do anything here")
                    case .fetching:
                        print("We don't need to do anything here")
                    case .notRunning:
                        cell.isUserInteractionEnabled = false
                    case .running:
                        print("We don't need to do anything here")
                    }
                }
                
            }
            
            // setting text, adding disclosure indicator, adding image, and increasing text size
            cell.textLabel?.text = options[indexPath.row]
            cell.imageView?.image = UIImage(named: images[indexPath.row])
            cell.accessoryType = .disclosureIndicator
            cell.textLabel?.font = UIFont.systemFont(ofSize: 18.0)
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
            
            // This is for the footer that displays the wait time.
            // with this we will have two labels: label (that displays "Welcome!")
            // we will then nest that label in a bigger label, backgroundLabel, that will create a white
            // background that can adjust the height
            
            // from there, we will nest the backgroundLabel in the view. The view is what is being diaplyed to the user
            
            let view = UIView()
            
            let label = UILabel()
            label.layoutMargins = UIEdgeInsets(top: 200, left: 10, bottom: 20, right: 4)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = "Welcome!"
            label.textColor = UIColor(red: 242.0/255.0 , green:  128.0/255.0 , blue :  43.0/255.0 , alpha: 100.0)
            label.font = UIFont.boldSystemFont(ofSize: 25.0)
            
            
            let backgroundLabel = UILabel()
            backgroundLabel.translatesAutoresizingMaskIntoConstraints = false
            backgroundLabel.backgroundColor = .white
            
            backgroundLabel.addSubview(label)
            
            backgroundLabel.leadingAnchor.constraint(equalTo: label.leadingAnchor, constant: -20).isActive = true
            backgroundLabel.trailingAnchor.constraint(equalTo: label.trailingAnchor).isActive = true
            backgroundLabel.topAnchor.constraint(equalTo: label.topAnchor, constant: -10).isActive = true
            backgroundLabel.bottomAnchor.constraint(equalTo: label.bottomAnchor, constant: 10).isActive = true
            
            view.addSubview(backgroundLabel)
            
            view.leadingAnchor.constraint(equalTo: backgroundLabel.leadingAnchor).isActive = true
            view.trailingAnchor.constraint(equalTo: backgroundLabel.trailingAnchor).isActive = true
            view.topAnchor.constraint(equalTo: backgroundLabel.topAnchor, constant: -20).isActive = true
            view.bottomAnchor.constraint(equalTo: backgroundLabel.bottomAnchor, constant: 20).isActive = true
            
            return view
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        if section == 0 {
            
            // This is for the footer that displays the wait time.
            // with this we will have two labels: label (that displays the literal text "wait time")
            // and the timeLabel (that displays the actual time)
            // we will then nest those two labels in a bigger label, backgroundLabel, that will create a white
            // background that can adjust the height
            
            // from there, we will nest the backgroundLabel in the view. The view is what is being diaplyed to the user
            
            let view = UIView()
            
            let backgroundLabel = UILabel()
            backgroundLabel.translatesAutoresizingMaskIntoConstraints = false
            backgroundLabel.backgroundColor = .white
            
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = "Wait time: "
            label.font = UIFont.systemFont(ofSize: 20.0)
            
            let timeLabel = UILabel()
            timeLabel.translatesAutoresizingMaskIntoConstraints = false

            if let rideStatus = rideStatus {
                switch rideStatus.state {
                case .initial:
                    timeLabel.text = "Loading..."
                case .fetching:
                    timeLabel.text = "Loading..."
                case .notRunning:
                    timeLabel.text = "Not Running"
                case .running(let waitTime):
                    timeLabel.text = waitTime.shortenWaitTime()
                }
            }
        
            timeLabel.font = UIFont.systemFont(ofSize: 20.0)
            timeLabel.textAlignment = NSTextAlignment.right
            
            backgroundLabel.addSubview(label)
            backgroundLabel.addSubview(timeLabel)
            
            view.addSubview(backgroundLabel)
            
            
            // adding constraints in code instead of storyboard
            backgroundLabel.leadingAnchor.constraint(equalTo: label.leadingAnchor, constant: -20).isActive = true
            backgroundLabel.topAnchor.constraint(equalTo: label.topAnchor, constant: -10).isActive = true
            backgroundLabel.bottomAnchor.constraint(equalTo: label.bottomAnchor, constant: 10).isActive = true
            
            label.widthAnchor.constraint(equalTo: timeLabel.widthAnchor).isActive = true
            label.trailingAnchor.constraint(equalTo: timeLabel.leadingAnchor, constant: -20).isActive = true
            
            backgroundLabel.trailingAnchor.constraint(equalTo: timeLabel.trailingAnchor, constant: 20).isActive = true
            backgroundLabel.topAnchor.constraint(equalTo: timeLabel.topAnchor, constant: -10).isActive = true
            backgroundLabel.bottomAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 10).isActive = true
            
            view.leadingAnchor.constraint(equalTo: backgroundLabel.leadingAnchor).isActive = true
            view.trailingAnchor.constraint(equalTo: backgroundLabel.trailingAnchor).isActive = true
            view.topAnchor.constraint(equalTo: backgroundLabel.topAnchor, constant: -20).isActive = true
            view.bottomAnchor.constraint(equalTo: backgroundLabel.bottomAnchor, constant: 10).isActive = true
            
            return view
        }
        
        return nil
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "STRIPES"

        // Do any additional setup after loading the view.
        
        let center = NotificationCenter.default
        center.addObserver(forName: RideStatus.rideStatusChange,
                           object: nil,
                           queue: OperationQueue.main) { notification in
                        self.tableView.reloadData()
        }
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
