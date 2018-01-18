//
//  HomeVCMapExtension.swift
//  ride-along-development
//
//  Created by Alisher Abdukarimov on 1/11/18.
//  Copyright © 2018 Alisher Abdukarimov. All rights reserved.
//

import MapKit
import UIKit
import Firebase

extension HomeVC: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        UpdateService.instance.updateDriverLocation(withCoordinate: userLocation.coordinate)
        UpdateService.instance.updateUserLocation(withCoordinate: userLocation.coordinate)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? DriverAnotation {
            let identifier = "driver"
            var view: MKAnnotationView
            view = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.image = UIImage(named: "driverAnnotation")
            return view
        } else if let annotation = annotation as? PassengerAnnotation {
            let identifier = "passenger"
            var view: MKAnnotationView
            view = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.image = UIImage(named: "currentLocationAnnotation")
            return view
        } else if let annotation = annotation as? MKPointAnnotation {
            let identifier = "destination"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            if annotationView == nil {
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            } else {
                annotationView?.annotation = annotation
            }
            annotationView?.image = UIImage(named: "destinationAnnotation")
            return annotationView
        } else {
            return nil
        }
    }
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
         centerMapBtn.fadeTo(alhpaValue: 1.0, withDuration: 2.0)
    }
    
    func performSearch() {
        matchingItems.removeAll()
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = locationTextField.text
        request.region = mapView.region
        
        let search = MKLocalSearch(request: request)
        
        search.start { (responce, error) in
            if error != nil {
                print(error?.localizedDescription ?? "Could not describe the error")
            } else if responce?.mapItems.count == 0 {
                print("No Results found")
            } else {
                for mapItem in responce!.mapItems {
                    self.matchingItems.append(mapItem)
                }
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: Drop pin
    
    func dropPinFor(placemark: MKPlacemark) {
        selectedItemPlacemark = placemark
        
        for annotation in mapView.annotations {
            if annotation.isKind(of: MKPointAnnotation.self) {
                mapView.removeAnnotation(annotation)
            }
        }
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        mapView.addAnnotation(annotation)
    }
    
    // Load coordinates from DataBase
    func loadDriverAnnotationFromDB() {
        DataService.instance.REF_DRIVERS.observeSingleEvent(of: .value) { (snapshot) in
            if let driverSnapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for driver in driverSnapshot {
                    if driver.hasChild("isDriver") {
                        if driver.hasChild("coordinate") {
                            if driver.childSnapshot(forPath: "isOnline").value as! Bool == true {
                                if let driverDict = driver.value as? Dictionary<String, Any> {
                                    let coordinateArray = driverDict["coordinate"] as! NSArray
                                    let driverCoordinate = CLLocationCoordinate2D(latitude: coordinateArray[0] as! CLLocationDegrees, longitude: coordinateArray[1] as! CLLocationDegrees)
                                    
                                    let annotation = DriverAnotation(coordinate: driverCoordinate, withKey: driver.key)
                                    
                                    var driverIsVisible: Bool {
                                        return self.mapView.annotations.contains(where: { (annotation) -> Bool in
                                            if let driverAnnotation = annotation as? DriverAnotation {
                                                if driverAnnotation.key == driver.key {
                                                    driverAnnotation.update(annotationPosition: driverAnnotation, withCoordinate: driverCoordinate)
                                                    self.mapView.addAnnotation(driverAnnotation)
                                                    return true
                                                }
                                            }
                                            return false
                                        })
                                    }
                                    
                                    if !driverIsVisible {
                                        self.mapView.addAnnotation(annotation)
                                    }
                                }
                            } else {
                                for annotation in self.mapView.annotations {
                                    if annotation.isKind(of: DriverAnotation.self) {
                                        if let annotation = annotation as? DriverAnotation {
                                            if annotation.key == driver.key {
                                                self.mapView.removeAnnotation(annotation)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
