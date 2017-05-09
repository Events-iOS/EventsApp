//
//  User.swift
//  Events
//
//  Created by Rajit Dang on 4/24/17.
//  Copyright © 2017 Events-iOS. All rights reserved.
//

import UIKit
import FirebaseDatabase

class User: NSObject {
    var uid: String!
    var firstName: String!
    var lastName: String!
    var email: String!
    var rsvpEvents: NSDictionary?
    var userLocation: (Double, Double)?
    var eventsCreated: [Int]?
    
    var user: NSDictionary?
    
    static let dbRef = FIRDatabase.database().reference()
    
    init(dictionary: NSDictionary) {
        user = dictionary
        if let user = user {
            if let uid = user["uid"] {
                self.uid = uid as! String
            }
            if let firstName = user["first_name"] {
               self.firstName = firstName as! String
            }
            if let lastName = user["last_name"] {
                self.lastName = lastName as! String
            }
            if let email = user["email"] {
                self.email = email as! String
            }
            rsvpEvents = user["rsvp_events"] as? NSDictionary
            let latitude = user["latitude"] as? Double
            let longitude = user["longitude"] as? Double
            userLocation = (latitude ?? 0.0, longitude ?? 0.0)
            eventsCreated = (user["eventsCreated"] as? [Int]) ?? []
        }
    }
    
    class func addUser(newUser: User, callback: @escaping (String)->()) {
        if let uid = newUser.uid {
            if let firstName = newUser.firstName, let lastName = newUser.lastName, let email = newUser.email {
                dbRef.child("users").child(uid)
                    .setValue(["first_name": firstName,
                               "last_name" : lastName,
                               "email" : email], withCompletionBlock: { (error: Error?, db: FIRDatabaseReference) in
                                if let error = error {
                                    callback(error as! String)
                                }
                                else {
                                    callback("success")
                                }
                    })
            }
        }
    }
}
