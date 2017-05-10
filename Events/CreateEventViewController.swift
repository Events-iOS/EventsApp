//
//  CreateEventViewController.swift
//  Events
//
//  Created by Sandeep Raghunandhan on 4/24/17.
//  Copyright © 2017 Events-iOS. All rights reserved.
//

import UIKit
import FirebaseDatabase

class CreateEventViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var eventName: UITextField!
    @IBOutlet weak var eventLocation: UITextField!

    @IBOutlet weak var eventCategory: UITextField!
    
    @IBOutlet weak var eventDescription: UITextField!
    
    @IBOutlet weak var maxCapacity: UITextField!
    @IBOutlet weak var eventImage: UIImageView!
    
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
        let eventDictionary : NSDictionary = ["title" : eventName.text ?? "Untitled", "category" : eventCategory.text ?? "Uncategorized", "location": eventLocation.text ?? "TBD", "description" : eventDescription.text ?? "No description",
            "max_capacity" : maxCapacity.text ?? "100"
        ]
        
        let event: Event = Event(dictionary: eventDictionary as! [String : AnyObject])
        let eventRef = self.ref?.child("events").childByAutoId()
        event.setEventId(eventId: (eventRef?.key)!)
        eventRef?.setValue(event.dict)
    }
    
    @IBAction func onCamera(_ sender: Any) {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            vc.sourceType = .camera
        }
        else {
            vc.sourceType = .photoLibrary
        }
        self.present(vc, animated: true) { 
            // Do nothing for now
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        eventImage.image = image
        
        dismiss(animated: true, completion: nil)
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
