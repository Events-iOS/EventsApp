//
//  CreateEventViewController.swift
//  Events
//
//  Created by Sandeep Raghunandhan on 4/24/17.
//  Copyright © 2017 Events-iOS. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import GooglePlaces
import GoogleMaps

class CreateEventViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var eventName: UITextField!
    @IBOutlet weak var eventLocation: UITextField!

    @IBOutlet weak var eventCategory: UITextField!
    
    @IBOutlet weak var eventDescription: UITextField!
    
    @IBOutlet weak var maxCapacity: UITextField!
    @IBOutlet weak var eventImage: UIImageView!
    
    
    
    var locationName: String?
    var mapsLocation: GMSPlace?
    var eventRef: FIRDatabaseReference?
    var ref: FIRDatabaseReference?
    

    var startDate : Date = Date()
    var endDate : Date = Date()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = FIRDatabase.database().reference()
        eventRef = self.ref?.child("events").childByAutoId()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  
    // When user presses on Location pressed
    @IBAction func onLocationButtonPressed(_ sender: Any) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    
    @IBAction func onEventSaved(_ sender: Any) {
        var eventDictionary : Dictionary = ["title" : eventName.text ?? "Untitled", "category" : eventCategory.text ?? "Uncategorized"
        ] as [String : Any]
        eventDictionary["location_name"] = locationName ?? "TBD"
        eventDictionary["location_address"] = eventLocation.text
        eventDictionary["description"] = eventDescription.text ?? "No description"
        eventDictionary["max_capacity"] = maxCapacity.text ?? "100"
        eventDictionary["id"] = eventRef!.key
        eventDictionary["startDate"] = startDate.timeIntervalSince1970
        eventDictionary["endDate"] = endDate.timeIntervalSince1970
        eventDictionary["location_latitude"] =  mapsLocation?.coordinate.latitude ?? 0.0
        eventDictionary["location_longitude"] =  mapsLocation?.coordinate.longitude ?? 0.0
        
        let event: Event = Event(dictionary: eventDictionary as! [String : AnyObject])
        eventRef?.setValue(event.dict)
        self.navigationController?.popViewController(animated: true)
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
        
        let storageRef = FIRStorage.storage().reference()
        
        var data = NSData()
        data = UIImageJPEGRepresentation(eventImage.image!, 0.8)! as NSData
        let metaData = FIRStorageMetadata()
        metaData.contentType = "image/jpg"
        let filePath = "events/\(eventRef!.key)"
        storageRef.child(filePath).put(data as Data, metadata: metaData) { (meta: FIRStorageMetadata?, error: Error?) in
            if let error = error {
                print(error)
            }
            else {
                let imageURL = metaData.downloadURL()?.absoluteString
                self.eventRef?.child("image").setValue(imageURL)
            }
        }
        
    }
    

    @IBAction func eventStartTimeSelected(_ sender: UIDatePicker) {
        self.startDate = sender.date
    }
    
    @IBAction func eventEndTimeSelected(_ sender: UIDatePicker) {
        self.endDate = sender.date
    }
    
    
    
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
}

extension CreateEventViewController: GMSAutocompleteViewControllerDelegate {
    // Handle the user's selection.
    public func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress ?? nil)")
        print("Place attributions: \(place.attributions ?? nil)")
        eventLocation.text = place.formattedAddress
        self.locationName = place.name
        self.mapsLocation = place
        dismiss(animated: true, completion: nil)
    }
    
    public func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    public func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    public func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    public func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}
