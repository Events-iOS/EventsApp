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
    var date: NSDate?
    var title: String?
    var eventDescription: String?
    
    var organizer: String?
    var location: String?
    var category: String?
    var max_capacity: Int?
    
    var attendees: [String]
    var numRSVP: Int
    var photos: [String]
    
    var event: NSDictionary?
    
    init(dictionary: NSDictionary) {
    }
}
