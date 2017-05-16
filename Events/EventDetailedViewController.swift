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


class EventDetailedViewController: UIViewController {

    @IBOutlet weak var eventLocation: UIButton!
    @IBOutlet weak var eventDate: UILabel!
    
    var event: Event!
    
    @IBOutlet weak var eventDescription: UILabel!
    
    @IBOutlet weak var eventMapView: UIView!
    
    var dbRef = FIRDatabase.database().reference()
    var storageRef = FIRStorage.storage().reference()
    
    @IBOutlet weak var eventImageView: UIImageView!

    
    @IBOutlet weak var eventTitle: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let camera = GMSCameraPosition.camera(withLatitude: (event.location?.0) ?? 0.0, longitude: (event.location?.1) ?? 0.0, zoom: 6.0)
        let mapView = GMSMapView.map(withFrame: eventMapView.bounds, camera: camera)
        
        // Create a marker in the center of the app
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = mapView
        
        self.eventMapView = mapView
        
        fetchImage()
        populatelabels()
    }
    
    func fetchImage() {
        dbRef.child("events").child(event.id!).observeSingleEvent(of: .value) { (snap: FIRDataSnapshot) in
            let imagePath = "events/\(self.event.id!)"
            let storageRef = FIRStorage.storage().reference()
            storageRef.child(imagePath).data(withMaxSize: 10*1024*1024, completion: { (data: Data?, error: Error?) in
                self.eventImageView.image = UIImage(data: data!)
            })
        }
    }
    
    func populatelabels() {
        eventTitle.text = event.title
        eventDescription.text = event.eventDescription
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
