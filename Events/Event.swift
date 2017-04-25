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
    var location: String?
    var category: String?
    var max_capacity: Int?
    
    var attendees: [String]?
    var numRSVP: Int?
//    var photos: [UIImage]
    
    var event: NSDictionary?
    
    init(dictionary: NSDictionary) {
        event = dictionary
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
        if let idText = dictionary["eventid"] as? String {
            id = idText
        }
        if let locationText = dictionary["location"] as? String {
            location = locationText
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
    }
    
    func setEventId(eventId: String) {
        id = eventId
    }
    
    
    var dict: [String:AnyObject] {
        return event as! [String : AnyObject]
    }
}
