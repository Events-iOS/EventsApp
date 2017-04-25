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
    
    var attendees: [String]
    var numRSVP: Int
//    var photos: [UIImage]
    
    var event: NSDictionary?
    
    init(dictionary: NSDictionary) {
        category = dictionary["category"] as? String
        attendees = (dictionary["attendees"] as? [String])!
        numRSVP = attendees.count
        eventDescription = dictionary["description"] as? String
        startDate = dictionary["start"] as? NSDate
        endDate = dictionary["endDate"] as? NSDate
        id = dictionary["eventid"] as? String
        location = dictionary["location"] as? String
        max_capacity = dictionary["maxCapacity"] as? Int
        startDate = dictionary["startDate"] as? NSDate
        title = dictionary["title"] as? String
    }
}
