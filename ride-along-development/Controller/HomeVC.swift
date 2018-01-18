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
    }
    
    
    // IBActions
    
    @IBAction func requestBtnTapped(_ sender: Any) {
        print("Btn is pressed")
        requestBtn.animateButton(shouldLoad: true, withMessage: nil)
    }
    
    @IBAction func menuBtnTapped(_ sender: Any) {
        delegate?.toggleLeftPanel()
    }
    
    @IBAction func centerBtnTapped(_ sender: Any) {
        centerMapOnUserLocation()
        centerMapBtn.fadeTo(alhpaValue: 0.0, withDuration: 0.2)
    }
    
}
