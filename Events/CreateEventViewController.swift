//
//  CreateEventViewController.swift
//  Events
//
//  Created by Sandeep Raghunandhan on 4/24/17.
//  Copyright © 2017 Events-iOS. All rights reserved.
//

import UIKit
import FirebaseDatabase

class CreateEventViewController: UIViewController {
    @IBOutlet weak var eventName: UITextField!
    @IBOutlet weak var eventLocation: UITextField!

    @IBOutlet weak var eventCategory: UITextField!
    
    @IBOutlet weak var eventDescription: UITextField!
    
    var ref: FIRDatabaseReference?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = FIRDatabase.database().reference()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onEventSaved(_ sender: Any) {
        var eventDictionary : NSDictionary = ["title" : eventName.text, "category" : eventCategory.text, "location": eventLocation.text, "description" : eventDescription.text]
        
        var event: Event = Event(dictionary: eventDictionary as! [String : AnyObject])
        var eventRef = self.ref?.child("events").childByAutoId()
        event.setEventId(eventId: (eventRef?.key)!)
        eventRef?.setValue(event.dict)
        
        
        
        
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
