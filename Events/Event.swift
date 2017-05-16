//
//  Event.swift
//  Events
//
//  Created by Rajit Dang on 4/17/17.
//  Copyright © 2017 Events-iOS. All rights reserved.
//

import UIKit

class Event: NSObject {
    var id: String?
    var startDate: NSDate?
    var endDate: NSDate?
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
        if let startDateText = dictionary["start"] as? NSDate {
            startDate = startDateText
        }
        if let endDateText = dictionary["endDate"] as? NSDate {
            endDate = endDateText
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
        if let startDateText = dictionary["startDate"] as? NSDate {
            startDate = startDateText
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
        formatter.dateFormat = "MMM d, yyyt"
        return formatter.string(from: date)
    }
    
    
    var dict: [String:AnyObject] {
        return event as! [String : AnyObject]
    }
}
