//
//  Event.swift
//  Events
//
//  Created by Rajit Dang on 4/17/17.
//  Copyright © 2017 Events-iOS. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import FirebaseAuth
import FirebaseDatabase


class Event: NSObject {
    var id: String?
    var startDate: Date?
    var endDate: Date?
    var title: String?
    var eventDescription: String?
    
    var organizer: String?
    var locationName: String?
    var LocationAddress: String?
    var locationLatitude: Double?
    var locationLongitude: Double?
    var category: String?
    var max_capacity: Int?
    
    var attendees: Dictionary<String, String>?
    var numRSVP: Int?
    
    var event: Dictionary<String, Any>?
    
    static let eventDBRef = FIRDatabase.database().reference().child("events")
    
    init(dictionary: Dictionary<String, Any>) {
        super.init()
        event = dictionary as Dictionary<String, Any>
        category = dictionary["category"] as? String
        if let attendeesDictionary = dictionary["attendees"] as? Dictionary<String, String> {
            attendees = attendeesDictionary
            numRSVP = returnRSVP(attendees: attendeesDictionary)
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
        
        if let location = dictionary["location_name"] as? String {
            self.locationName = location
        }
        
        if let locationAddress = dictionary["location_address"] as? String {
            self.LocationAddress = locationAddress
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
        
        if let locationLatitude = dictionary["location_latitude"] as? Double {
            self.locationLatitude = locationLatitude
        }
        
        if let locationLongitude = dictionary["location_longitude"] as? Double {
            self.locationLongitude = locationLongitude
        }
        
        if let organizer = dictionary["organizer"] as? String {
            self.organizer = organizer
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
    
    
    var dict: Dictionary<String, Any> {
        return event!
    }
    
    func returnRSVP(attendees: Dictionary<String, String>) -> Int {
        var count = 0
        for attendee in attendees {
            if attendee.value == "Going" {
                count = count + 1
            }
        }
        
        return count
    }
}
