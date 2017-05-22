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

class EventCell: UITableViewCell {

    @IBOutlet weak var eventDescriptionLabel: UILabel!
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var goingButton: UIButton!
    @IBOutlet weak var maybeButton: UIButton!
    @IBOutlet weak var notgoingButton: UIButton!
    
    
    
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
        print("going selected")
        goingButton.alpha = 1
        
        maybeButton.alpha = 0.4
        notgoingButton.alpha = 0.4
        
        Event.RSVP(event: event, status: "Going")
    }
    @IBAction func maybeSelected(_ sender: Any) {
        print("maybe selected")
        maybeButton.alpha = 1
        
        goingButton.alpha = 0.4
        notgoingButton.alpha = 0.4
        
        Event.RSVP(event: event, status: "Maybe")
    }
    @IBAction func notgoingSelected(_ sender: Any) {
        print("not going selected")
        notgoingButton.alpha = 1
        
        goingButton.alpha = 0.4
        maybeButton.alpha = 0.4
        
        Event.RSVP(event: event, status: "Not Going")
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
        }
    }
}
