//
//  EventDetailedViewController.swift
//  Events
//
//  Created by Rajit Dang on 5/1/17.
//  Copyright © 2017 Events-iOS. All rights reserved.
//

import UIKit
import GoogleMaps
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth

class EventDetailedViewController: UIViewController {

    @IBOutlet weak var eventLocation: UILabel!

    @IBOutlet weak var eventDate: UILabel!
    
    var event: Event!
    
    @IBOutlet weak var eventDescription: UILabel!
    
    @IBOutlet weak var numRSVPLabel: UILabel!

    
    var dbRef = FIRDatabase.database().reference()
    var storageRef = FIRStorage.storage().reference()
    
    @IBOutlet weak var eventImageView: UIImageView!

    
    @IBOutlet weak var eventTitle: UILabel!
    
    @IBOutlet weak var eventMapView: GMSMapView!
    
    @IBOutlet weak var eventOrganizer: UILabel!
    
    
    @IBOutlet weak var goingButton: UIButton!
    @IBOutlet weak var maybeButton: UIButton!
    @IBOutlet weak var notGoingButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let camera = GMSCameraPosition.camera(withLatitude: (event.locationLatitude!) , longitude: (event.locationLongitude!), zoom: 14.0)
        self.eventMapView.camera = camera
        
        // Create a marker in the center of the app
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: event.locationLatitude!, longitude: event.locationLongitude!)
        marker.title = event.locationName
        marker.snippet = "Australia"
        marker.map = eventMapView
    
        fetchImage()
        populatelabels()
        displayRSVP(id: event!.id!)
    }
    
    func displayRSVP(id: String) {
        let currentUser = FIRAuth.auth()?.currentUser?.uid
        dbRef.child("events").child(id).child("attendees").child(currentUser!).observeSingleEvent(of: .value) { (snapshot: FIRDataSnapshot) in
            let status = "\(snapshot.value!)"
            print(status)
            if status == "Going" {
                self.setGoing()
            }
            if status == "Maybe" {
                self.setMaybe()
            }
            if status == "Not Going" {
                self.setNotGoing()
            }
        }
    }
    
    func fetchImage() {
        dbRef.child("events").child(event.id!).observeSingleEvent(of: .value) { (snap: FIRDataSnapshot) in
            let imagePath = "events/\(self.event.id!)"
            let storageRef = FIRStorage.storage().reference()
            storageRef.child(imagePath).data(withMaxSize: 10*1024*1024, completion: { (data: Data?, error: Error?) in
                if let data = data {
                    self.eventImageView.image = UIImage(data: data)
                }
            })
        }
    }
    
    
    @IBAction func goingButtonSelected(_ sender: Any) {
        setGoing()
        Event.RSVP(event: event, status: "Going")

    }
    
    
    @IBAction func maybeButtonSelected(_ sender: Any) {
        setMaybe()
        Event.RSVP(event: event, status: "Maybe")
    }
    
    
    @IBAction func notGoingButtonSelected(_ sender: Any) {
        setNotGoing()
        Event.RSVP(event: event, status: "Not Going")

    }
    func populatelabels() {
        eventTitle.text = event.title
        eventDescription.text = event.eventDescription
        if let startDate = event.startDate {
            eventDate.text = Event.formatDate(date: startDate)
        }
        if let locName = event.locationName {
            eventLocation.text = locName
        }
        if let organizer = event.organizer {
            eventOrganizer.text = organizer
        }
        
        if let rsvp_num = event.numRSVP {
            if rsvp_num == 0 {
                numRSVPLabel.text = "Nobody is coming :("
            } else {
                numRSVPLabel.text = "\(rsvp_num) attending"
            }
        } else {
            numRSVPLabel.text = "Autism"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setGoing() {
        goingButton.alpha = 1
        maybeButton.alpha = 0.4
        notGoingButton.alpha = 0.4
    }

    func setNotGoing() {
        notGoingButton.alpha = 1
        goingButton.alpha = 0.4
        maybeButton.alpha = 0.4
    }
    
    func setMaybe() {
        maybeButton.alpha = 1
        goingButton.alpha = 0.4
        notGoingButton.alpha = 0.4
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editEvent" {
            let editView = segue.destination as! CreateEventViewController
            editView.event = event
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
}
