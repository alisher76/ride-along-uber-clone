//
//  HomeVC.swift
//  ride-along-development
//
//  Created by Alisher Abdukarimov on 1/1/18.
//  Copyright © 2018 Alisher Abdukarimov. All rights reserved.
//

import UIKit
import MapKit
import RevealingSplashView
import CoreLocation
import Firebase

class HomeVC: UIViewController {

    // Outlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var requestBtn: RoundedShadowButton!
    @IBOutlet weak var centerMapBtn: UIButton!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var locationCircle: CircleView!
    
    
    // Properties
    var delegate: CenterVCDelegate?
    let revealingSplashView = RevealingSplashView(iconImage: UIImage(named: "RALogo")!, iconInitialSize: CGSize(width: 80, height: 80), backgroundColor: UIColor.white)
    var manager: CLLocationManager?
    var tableView = UITableView()
    var regionRadius: CLLocationDistance = 1000
    var selectedItemPlacemark: MKPlacemark? = nil
    var matchingItems: [MKMapItem] = [MKMapItem]()
    var route: MKRoute!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Delegates
        mapView.delegate = self
        locationTextField.delegate = self
        
        manager = CLLocationManager()
        manager?.delegate = self
        manager?.desiredAccuracy = kCLLocationAccuracyBest
        checkLocationAuthStatus()
    
        centerMapOnUserLocation()
        
        DataService.instance.REF_DRIVERS.observe(.value) { (snapshot) in
            self.loadDriverAnnotationFromDB()
        }
        
        self.view.addSubview(revealingSplashView)
        revealingSplashView.animationType = .heartBeat
        revealingSplashView.startAnimation()
        revealingSplashView.heartAttack = true
        
        UpdateService.instance.observeTrips { (tripDict) in
            if let tripDict = tripDict {
                let pickUpCoordinateArray = tripDict["pickUpCoordinate"] as! NSArray
                let tripKey = tripDict["passengerKey"] as! String
                let acceptanceStatus = tripDict["tripAccepted"] as! Bool
                if acceptanceStatus == false {
                    DataService.instance.driverIsAvailable(key: (Auth.auth().currentUser?.uid)!, handler: { (available) in
                        if available {
                            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                            let pickUpVC = storyboard.instantiateViewController(withIdentifier: "pickupVC") as! PickUpVC
                            pickUpVC.initData(coordinate: CLLocationCoordinate2D(latitude: pickUpCoordinateArray[0] as! CLLocationDegrees, longitude: pickUpCoordinateArray[1] as! CLLocationDegrees) , passengerKey: tripKey)
                            self.present(pickUpVC, animated: true, completion: nil)
                        }
                    })
                }
            }
        }
    }
    
    
    // IBActions
    
    @IBAction func requestBtnTapped(_ sender: Any) {
        UpdateService.instance.updateTripWithCoordinate()
        requestBtn.animateButton(shouldLoad: true, withMessage: nil)
        
        self.view.endEditing(true)
        locationTextField.isUserInteractionEnabled = false
    }
    
    @IBAction func menuBtnTapped(_ sender: Any) {
        delegate?.toggleLeftPanel()
    }
    
    @IBAction func centerBtnTapped(_ sender: Any) {
        centerMapOnUserLocation()
        centerMapBtn.fadeTo(alhpaValue: 0.0, withDuration: 0.2)
    }
    
}
