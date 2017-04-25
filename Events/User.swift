//
//  User.swift
//  Events
//
//  Created by Rajit Dang on 4/24/17.
//  Copyright © 2017 Events-iOS. All rights reserved.
//

import UIKit

class User: NSObject {
    var uid: String?
    var firstName: String?
    var email: String?
    var isVerified: Bool?
    var rsvpEvents: NSDictionary?
    var userLocation: (Double, Double)
    var eventsCreated: [Int]
    
    var user: NSDictionary?
    
    init(dictionary: NSDictionary) {
        uid = user?["uid"] as? String
        firstName = user?["first_name"] as? String
        email = user?["email"] as? String
        isVerified = user?["is_verified"] as? Bool
        rsvpEvents = user?["rsvp_events"] as? NSDictionary
        let latitude = user?["latitude"] as? Double
        let longitude = user?["longitude"] as? Double
        userLocation = (latitude!, longitude!)
        eventsCreated = (user?["eventsCreated"] as? [Int])!
    }
}
