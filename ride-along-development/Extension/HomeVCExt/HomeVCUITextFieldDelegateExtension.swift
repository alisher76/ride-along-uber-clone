//
//  HomeVCUITextFieldDelegateExtension.swift
//  ride-along-development
//
//  Created by Alisher Abdukarimov on 1/11/18.
//  Copyright © 2018 Alisher Abdukarimov. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import MapKit

extension HomeVC: UITextFieldDelegate {
    
    // When TextField selected show tableview
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == locationTextField {
            tableView.frame = CGRect(x: 20, y: view.frame.height, width: view.frame.width - 40, height: view.frame.height - 170)
            tableView.layer.cornerRadius = 5.0
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "locationCell")
            
            tableView.delegate = self
            tableView.dataSource = self
            // TAG TABLEVIEW = 17
            tableView.tag = 17
            tableView.rowHeight = 60
            
            view.addSubview(tableView)
            animateTableView(shouldShow: true)
            
            UIView.animate(withDuration: 0.3, animations: {
                self.locationCircle.backgroundColor = UIColor.red
                self.locationCircle.borderColor = UIColor(red: 199/255, green: 0/255, blue: 0/255, alpha: 1.0)
            })
        }
    }
    
    func animateTableView(shouldShow: Bool) {
        if shouldShow {
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: .curveEaseInOut, animations: {
                 self.tableView.frame = CGRect(x: 15, y: 200, width: self.view.frame.width - 30, height: self.view.frame.height - 340)
            }, completion: nil)
        } else {
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: .curveEaseInOut, animations: {
                self.tableView.frame = CGRect(x: 15, y: self.view.frame.height, width: self.view.frame.width - 30, height: self.view.frame.height - 340)
            }, completion: { (success) in
                for subview in self.view.subviews {
                    if subview.tag == 17 {
                        subview.removeFromSuperview()
                    }
                }
            })
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == locationTextField {
            performSearch()
            shouldPresentLoadingView(true)
            view.endEditing(true)
        }
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == locationTextField {
            if locationTextField.text == "" {
                UIView.animate(withDuration: 0.2, animations: {
                    self.locationCircle.backgroundColor = UIColor.lightGray
                    self.locationCircle.borderColor = UIColor.darkGray
                    self.animateTableView(shouldShow: false)
                })
            }
        }
    }

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        self.matchingItems.removeAll()
        self.tableView.reloadData()
    DataService.instance.REF_USERS.child((Auth.auth().currentUser?.uid)!).child("tripCoordinate").removeValue()
        mapView.removeOverlays(mapView.overlays)
        for annotation in mapView.annotations {
            if let annotation = annotation as? MKPointAnnotation {
                mapView.removeAnnotation(annotation)
            } else if annotation.isKind(of: PassengerAnnotation.self) {
                mapView.removeAnnotation(annotation)
            }
        }
        
        centerMapOnUserLocation()
        return true
    }
}


// Data Source
extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if matchingItems.count != 0 {
            return matchingItems.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "locationCell")
         let mapItem = matchingItems[indexPath.row]
         cell.textLabel?.text = mapItem.name
         cell.detailTextLabel?.text = mapItem.placemark.title  
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }
        let passengerCoordinate = manager?.location?.coordinate
        let passengerAnnotation = PassengerAnnotation(coordinate: passengerCoordinate!, key: currentUserID)
        mapView.addAnnotation(passengerAnnotation)
        locationTextField.text = tableView.cellForRow(at: indexPath)?.textLabel?.text
        
        let selectedMapItem = matchingItems[indexPath.row]
        
        DataService.instance.REF_USERS.child(currentUserID).updateChildValues(["tripCoordinate": [selectedMapItem.placemark.coordinate.latitude, selectedMapItem.placemark.coordinate.longitude]])
        dropPinFor(placemark: selectedMapItem.placemark)
        
        searchMapKitForResultWithPolyline(forMapItem: selectedMapItem)
        
        animateTableView(shouldShow: false)
        self.shouldPresentLoadingView(true)
    }
    
}
