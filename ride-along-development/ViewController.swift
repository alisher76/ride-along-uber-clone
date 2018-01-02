//
//  ViewController.swift
//  ride-along-development
//
//  Created by Alisher Abdukarimov on 1/1/18.
//  Copyright © 2018 Alisher Abdukarimov. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var requestBtn: RoundedShadowButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func requestBtnTapped(_ sender: Any) {
        print("Btn is pressed")
        requestBtn.animateButton(shouldLoad: true, withMessage: nil)
    }
    

}

