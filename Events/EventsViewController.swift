//
//  EventsViewController.swift
//  Events
//
//  Created by Rajit Dang on 4/17/17.
//  Copyright © 2017 Events-iOS. All rights reserved.
//

import UIKit
import FirebaseDatabase

class EventsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var events: [Event]?
    var ref: FIRDatabaseReference = FIRDatabase.database().reference()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 125
        // Do any additional setup after loading the view.
        fetchEvents()
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchEvents() {
        let eventRef = ref.child("events")
        eventRef.observe(.value, with: { (snapshot) in
            self.events = []
            for snap in snapshot.children {
                let event = snap as! FIRDataSnapshot
                let eventObj = Event(dictionary: event.value as! [String: AnyObject])
                self.events?.append(eventObj)
                self.tableView.reloadData()
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let events = events {
            return events.count
        } else {
            events = []
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as! EventCell
        let event = events?[indexPath.row]
        cell.event = event
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "detailsSegue" {
                let cell = sender as! EventCell
                let indexPath = tableView.indexPath(for: cell)
                let event = events![(indexPath!.row)]
            
                let detailedViewController = segue.destination as! EventDetailedViewController
                detailedViewController.event = event
            }
        }
       
}
