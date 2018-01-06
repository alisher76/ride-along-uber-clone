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

class HomeVC: UIViewController, MKMapViewDelegate {

    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var requestBtn: RoundedShadowButton!
    
    var delegate: CenterVCDelegate?
    let revealingSplashView = RevealingSplashView(iconImage: UIImage(named: "RALogo")!, iconInitialSize: CGSize(width: 80, height: 80), backgroundColor: UIColor.white)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        self.view.addSubview(revealingSplashView)
        revealingSplashView.animationType = .heartBeat
        revealingSplashView.startAnimation()
        
        revealingSplashView.heartAttack = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func requestBtnTapped(_ sender: Any) {
        print("Btn is pressed")
        requestBtn.animateButton(shouldLoad: true, withMessage: nil)
    }
    
    @IBAction func menuBtnTapped(_ sender: Any) {
        delegate?.toggleLeftPanel()
    }
    
}

