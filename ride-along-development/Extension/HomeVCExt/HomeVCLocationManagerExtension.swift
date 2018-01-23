//
//  HomeVCLocationManagerExtension.swift
//  ride-along-development
//
//  Created by Alisher Abdukarimov on 1/11/18.
//  Copyright © 2018 Alisher Abdukarimov. All rights reserved.
//

import MapKit
import UIKit
import CoreLocation
import Firebase

extension HomeVC: CLLocationManagerDelegate {
    
    
    func checkLocationAuthStatus() {
        
        if CLLocationManager.authorizationStatus() == .authorizedAlways {
            manager?.startUpdatingLocation()
        } else {
            manager?.requestAlwaysAuthorization()
        }
    }
    
    func centerMapOnUserLocation() {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            return
        }
        DataService.instance.REF_USERS.observeSingleEvent(of: .value) { (snapshot) in
            if let userSnapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for user in userSnapshot {
                    if user.key == currentUserID {
                        if user.hasChild("tripCoordinate") {
                            self.zoom(toFitAnnotationFromMapView: self.mapView)
                            self.centerMapBtn.fadeTo(alhpaValue: 0.0, withDuration: 0.2)
                        } else {
                            self.centerMapOnUserLocation()
                            self.centerMapBtn.fadeTo(alhpaValue: 0.0, withDuration: 0.2)
                        }
                    }
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthStatus()
        if status == .authorizedAlways {
            mapView.showsUserLocation = true
            mapView.userTrackingMode = .follow
        }
    }
}
