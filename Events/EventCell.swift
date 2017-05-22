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
    
    let dbRef: FIRDatabaseReference = FIRDatabase.database().reference()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
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
            locationLabel.text = event.locationName ?? "TBD"
            if let eventDate = event.startDate {
                dateLabel.text = Event.formatDate(date: eventDate)
            }
        }
    }
}
