//
//  Event.swift
//  Events
//
//  Created by Rajit Dang on 4/17/17.
//  Copyright © 2017 Events-iOS. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class Event: NSObject {
    var id: String?
    var startDate: Date?
    var endDate: Date?
    var title: String?
    var eventDescription: String?
    
    var organizer: String?
    var location: (Double, Double)?
    var locationDescription: String?
    var category: String?
    var max_capacity: Int?
    
    var attendees: [String]?
    var numRSVP: Int?
    
    var event: NSDictionary?
    
    static let eventDBRef = FIRDatabase.database().reference().child("events")
    
    init(dictionary: [String: AnyObject]) {
        event = dictionary as NSDictionary
        category = dictionary["category"] as? String
        if let attendeesText = dictionary["attendees"] as? [String] {
            attendees = attendeesText
            numRSVP = attendees?.count
        }
        if let eventDescriptionText = dictionary["description"] as? String {
            eventDescription = eventDescriptionText
        }
        if let endDateText = dictionary["endDate"] as? TimeInterval {
            endDate = Date.init(timeIntervalSince1970: endDateText)
        }
        if let idText = dictionary["id"] as? String {
            id = idText
        }
        if let location = dictionary["location"] as? (Double, Double) {
            self.location = location
        }
        if let max_capacityText = dictionary["maxCapacity"] as? Int {
            max_capacity = max_capacityText
        }
        if let startDateText = dictionary["startDate"] as? TimeInterval {
            startDate = Date.init(timeIntervalSince1970: startDateText)
        }
        if let titleText = dictionary["title"] as? String {
            title = titleText
        }
        else {
            title = "Untitled"
        }
    }
    
    func setEventId(eventId: String) {
        id = eventId
    }
    
    class func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = "MMM d / h:mm a"
        return formatter.string(from: date)
    }
    
    class func RSVP(event: Event, status: String) {
        eventDBRef.child(event.id!).child("attendees").child((FIRAuth.auth()?.currentUser?.uid)!).setValue(status)
    }
    
    
    var dict: [String:AnyObject] {
        return event as! [String : AnyObject]
    }
}
