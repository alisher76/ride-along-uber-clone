//
//  PickUpVC.swift
//  ride-along-development
//
//  Created by Alisher Abdukarimov on 1/24/18.
//  Copyright © 2018 Alisher Abdukarimov. All rights reserved.
//

import UIKit
import MapKit

class PickUpVC: UIViewController {
    
    
    @IBOutlet weak var pickUpMapView: RoundMapView!
    
    let regionRadius: CLLocationDistance = 2000
    var pin: MKPlacemark? = nil
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancelBtnTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func acceptBtnTapped(_ sender: Any) {
        
    }
    
}


extension PickUpVC: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let identifier = "pickUpPoint"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        } else {
            annotationView?.annotation = annotation
        }
        
        annotationView?.image = UIImage(named: "destinationAnnotation")
        
        return annotationView
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
        pickUpMapView.setRegion(coordinateRegion, animated: true)
    }
    
    func dropPinFor(placemark: MKPlacemark) {
        pin = placemark
        
        for annotaion in pickUpMapView.annotations {
            pickUpMapView.removeAnnotation(annotaion)
        }
        
        let annotaion = MKPointAnnotation()
        annotaion.coordinate = placemark.coordinate
        
        pickUpMapView.addAnnotation(annotaion)
    }
}
