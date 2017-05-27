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

    @IBOutlet weak var mapView: GMSMapView!


    @IBOutlet weak var bigMapView: GMSMapView!


    @IBOutlet weak var saveButton: UIButton!

    
    var event: Event?

    var locationName: String?
    var mapsLocation: GMSPlace?
    var eventRef: FIRDatabaseReference?
    var ref: FIRDatabaseReference?


    var startDate : Date = Date()
    var endDate : Date = Date()

    @IBOutlet weak var startDatepicker: UIDatePicker!
    @IBOutlet weak var endDatepicker: UIDatePicker!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        ref = FIRDatabase.database().reference()
        eventRef = self.ref?.child("events").childByAutoId()
        if let event = event {
            let dbRef = FIRDatabase.database().reference()
            eventName.text = event.title
            eventDescription.text = event.eventDescription
            eventCategory.text = event.category
            maxCapacity.text = event.max_capacity
            eventLocation.text = event.LocationAddress
            
            let camera = GMSCameraPosition.camera(withLatitude: (event.locationLatitude)! , longitude: (event.locationLatitude)!, zoom: 14.0)
            self.bigMapView.isUserInteractionEnabled = true
            self.bigMapView.camera = camera
            eventImage.isHidden = true
            mapView.isHidden = true
            
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: event.locationLatitude!, longitude: event.locationLongitude!)
            marker.snippet = event.locationName
            marker.title = event.LocationAddress
            marker.map = bigMapView
            
            dbRef.child("events").child((event.id!)).observeSingleEvent(of: .value) { (snap: FIRDataSnapshot) in
                let imagePath = "events/\(self.event?.id!)"
                let storageRef = FIRStorage.storage().reference()
                storageRef.child(imagePath).data(withMaxSize: 10*1024*1024, completion: { (data: Data?, error: Error?) in
                    // Deep, we got a segfault for this. just check it out.. :)
                    if let data = data {
                        self.eventImage.image = UIImage(data: data)
                    }
                })
            }
        } else {
            print("Sandeep, wtf?")
        }
        if let eventImage = eventImage.image {
            bigMapView.isHidden = true
        } else {
            mapView.isHidden = true
            eventImage.isHidden = true
        }



        startDatepicker.setValue(UIColor.white, forKey: "textColor")
        endDatepicker.setValue(UIColor.white, forKey: "textColor")

        saveButton.layer.cornerRadius = 5
        saveButton.layer.borderWidth = 2.0
        saveButton.layer.borderColor = UIColor.white.cgColor


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
        if let updatedEvent = event {
            print(updatedEvent.dict)
            let newEventRef = FIRDatabase.database().reference().child("events").child(updatedEvent.id!)
            event?.title = eventName.text
            event?.eventDescription = eventDescription.text
            event?.category = eventCategory.text
            event?.locationName = locationName
            event?.max_capacity = maxCapacity.text
            event?.locationLatitude = mapsLocation?.coordinate.latitude ?? 0.0
            event?.locationLongitude = mapsLocation?.coordinate.longitude ?? 0.0
            event?.LocationAddress = eventLocation.text
            print(event!.dict)
            newEventRef.setValue(event!.dict)
            
            self.performSegue(withIdentifier: "eventEditted", sender: nil)
            return
        }
        var eventDictionary = ["title" : eventName.text ?? "Untitled", "category" : eventCategory.text ?? "Uncategorized"
        ] as Dictionary<String, Any>
        eventDictionary["location_name"] = locationName ?? "TBD"
        eventDictionary["location_address"] = eventLocation.text
        eventDictionary["description"] = eventDescription.text ?? "No description"
        eventDictionary["max_capacity"] = maxCapacity.text ?? "100"
        eventDictionary["id"] = eventRef!.key
        eventDictionary["startDate"] = startDate.timeIntervalSince1970
        eventDictionary["endDate"] = endDate.timeIntervalSince1970
        eventDictionary["location_latitude"] =  mapsLocation?.coordinate.latitude ?? 0.0
        eventDictionary["location_longitude"] =  mapsLocation?.coordinate.longitude ?? 0.0
        User.currentUser(completion: { (user: User) in
            eventDictionary["organizer"] = user.firstName + " " + user.lastName
            let event = Event(dictionary: eventDictionary)
            self.eventRef?.setValue(event.dict)
            self.navigationController?.popViewController(animated: true)
        })
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
        self.bigMapView.isHidden = true
        self.mapView.isHidden = false
        self.eventImage.isHidden = false


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
        print("Place address: \(String(describing: place.formattedAddress ?? nil))")
        print("Place attributions: \(String(describing: place.attributions ?? nil))")
        eventLocation.text = place.formattedAddress
        self.locationName = place.name
        self.mapsLocation = place

        // Create a marker in the center of the app
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        marker.snippet = place.name
        marker.title = place.formattedAddress

        let camera = GMSCameraPosition.camera(withLatitude: (place.coordinate.latitude) , longitude: (place.coordinate.longitude), zoom: 14.0)

        if let eventImage = eventImage.image {
            bigMapView.isHidden = true
            self.mapView.isUserInteractionEnabled = true
            self.mapView.camera = camera
            marker.map = mapView

        } else {
            self.bigMapView.isUserInteractionEnabled = true
            self.bigMapView.camera = camera
            eventImage.isHidden = true
            mapView.isHidden = true
            marker.map = bigMapView
        }

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
