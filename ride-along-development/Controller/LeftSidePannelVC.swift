//
//  LeftSidePannelVC.swift
//  ride-along-development
//
//  Created by Alisher Abdukarimov on 1/2/18.
//  Copyright © 2018 Alisher Abdukarimov. All rights reserved.
//

import UIKit

class LeftSidePannelVC: UIViewController {

    // Outlets
    @IBOutlet weak var lgnBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // IBActions
    
    @IBAction func lgnBtnTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let loginVC = storyboard.instantiateViewController(withIdentifier: "loginVC") as? LoginVC else { return }
        present(loginVC, animated: true, completion: nil)
    }
    
    @IBAction func paymentBtntapped(_ sender: Any) {
    }
    @IBAction func tripsTakenBtnTapped(_ sender: Any) {
    }
    @IBAction func helpBtnTapped(_ sender: Any) {
    }
    @IBAction func settingBtnTapped(_ sender: Any) {
    }
    
    
    
    
}
