//
//  UpdateService.swift
//  ride-along-development
//
//  Created by Alisher Abdukarimov on 1/11/18.
//  Copyright © 2018 Alisher Abdukarimov. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import MapKit

class UpdateService {
    
    static let instance = UpdateService()
    
    func updateDriverLocation(withCoordinate coordinate: CLLocationCoordinate2D) {
        DataService.instance.REF_DRIVERS.observeSingleEvent(of: .value) { (snapshot) in
            if let driverSnapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for driver in driverSnapshot {
                    if driver.key == Auth.auth().currentUser?.uid {
                        if driver.childSnapshot(forPath: "isOnline").value as! Bool == true {
                            DataService.instance.REF_DRIVERS.child(driver.key).updateChildValues(["coordinate" : [coordinate.latitude, coordinate.longitude]])
                        }
                    }
                }
            }
        }
    }
    
    func updateUserLocation(withCoordinate coordinate: CLLocationCoordinate2D) {
        DataService.instance.REF_USERS.observeSingleEvent(of: .value) { (snapshot) in
            if let passengerSnapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for passenger in passengerSnapshot {
                    if passenger.key == Auth.auth().currentUser?.uid {
                        DataService.instance.REF_USERS.child(passenger.key).updateChildValues(["coordinate" : [coordinate.latitude, coordinate.longitude]])
                    } 
                }
            }
        }
    }
    
    // Observing trips
    
    func observeTrips(handler: @escaping(_ coordinateDict: [String:Any]?) -> Void) {
        DataService.instance.REF_TRIPS.observe(.value) { (snapshot) in
            if let tripSnapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for trip in tripSnapshot {
                    if trip.hasChild("passengerKey") && trip.hasChild("tripAccepted") {
                        if let tripDict = trip.value as? [String:Any] {
                            handler(tripDict)
                        }
                    }
                }
            }
        }
    }
    
    // MARK: Update trips with coordinates upon request
    
    func updateTripWithCoordinate() {
        DataService.instance.REF_USERS.observeSingleEvent(of: .value) { (dataSnapshot) in
            if let usersSnapshot = dataSnapshot.children.allObjects as? [DataSnapshot] {
                for userSnap in usersSnapshot {
                    if userSnap.key == Auth.auth().currentUser?.uid {
                        if !userSnap.hasChild("isDriver") {
                            if let userDict = userSnap.value as? [String:Any] {
                                let pickUpArray = userDict["coordinate"] as! NSArray
                                let destinationArray = userDict["tripCoordinate"] as! NSArray
                                
                                DataService.instance.REF_TRIPS.child(userSnap.key).updateChildValues(["pickUpCoordinate": [pickUpArray[0], pickUpArray[1]], "destination" : [destinationArray[0], destinationArray[1]], "passengerKey": userSnap.key, "tripAccepted" : false])
                            }
                        }
                    }
                }
            }
        }
    }
}
