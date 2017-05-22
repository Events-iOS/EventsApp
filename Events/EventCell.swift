//
//  TableViewCell.swift
//  Events
//
//  Created by Rajit Dang on 4/17/17.
//  Copyright © 2017 Events-iOS. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth

class EventCell: UITableViewCell {

    @IBOutlet weak var eventDescriptionLabel: UILabel!
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var goingButton: UIButton!
    @IBOutlet weak var maybeButton: UIButton!
    @IBOutlet weak var notgoingButton: UIButton!
    
    let currentUser = FIRAuth.auth()?.currentUser?.uid
    
    
    
    let dbRef: FIRDatabaseReference = FIRDatabase.database().reference()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @IBAction func goingSelected(_ sender: Any) {
        setGoing()
        Event.RSVP(event: event, status: "Going")
    }
    
    func setGoing() {
        goingButton.alpha = 1
        maybeButton.alpha = 0.4
        notgoingButton.alpha = 0.4
    }
    
    @IBAction func maybeSelected(_ sender: Any) {
        setMaybe()
        Event.RSVP(event: event, status: "Maybe")
    }
    
    func setMaybe() {
        maybeButton.alpha = 1
        goingButton.alpha = 0.4
        notgoingButton.alpha = 0.4
    }
    
    @IBAction func notgoingSelected(_ sender: Any) {
        setNotGoing()
        Event.RSVP(event: event, status: "Not Going")
    }
    
    func setNotGoing() {
        notgoingButton.alpha = 1
        goingButton.alpha = 0.4
        maybeButton.alpha = 0.4
    }
    
    
    func displayRSVP(id: String) {
        dbRef.child("events").child(id).child("attendees").child(currentUser!).observeSingleEvent(of: .value) { (snapshot: FIRDataSnapshot) in
            let status = "\(snapshot.value!)"
            print(status)
            if status == "Going" {
                self.setGoing()
            }
            if status == "Maybe" {
                self.setMaybe()
            }
            if status == "Not Going" {
                self.setNotGoing()
            }
        }
    }
    
    
    var event: Event! {
        didSet {
            eventDescriptionLabel.text = event.title
            dbRef.child("events").child(event.id!).observeSingleEvent(of: .value) { (snap: FIRDataSnapshot) in
                let imagePath = "events/\(self.event.id!)"
                let storageRef = FIRStorage.storage().reference()
                storageRef.child(imagePath).data(withMaxSize: 10*1024*1024, completion: { (data: Data?, error: Error?) in
                    // Deep, we got a segfault for this. just check it out.. :)
                    self.eventImageView.image = UIImage(data: data!)
                })
            }
            locationLabel.text = "\(event.location ?? (0,0))"
            if let eventDate = event.startDate {
                dateLabel.text = Event.formatDate(date: eventDate)
            }
            displayRSVP(id: event.id!)
        }
    }
}
