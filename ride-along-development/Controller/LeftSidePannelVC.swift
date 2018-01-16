//
//  LeftSidePannelVC.swift
//  ride-along-development
//
//  Created by Alisher Abdukarimov on 1/2/18.
//  Copyright © 2018 Alisher Abdukarimov. All rights reserved.
//

import UIKit
import Firebase

class LeftSidePannelVC: UIViewController {
    
    let appDelegate = AppDelegate.getAppDelegate()

    // Outlets
    @IBOutlet weak var lgnBtn: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var modeLabel: UILabel!
    @IBOutlet weak var profileImage: RoundImageView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var switchController: UISwitch!
    @IBOutlet weak var userTypeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // by default switch will be off
        switchController.isOn = false
        switchController.isHidden = true
        modeLabel.isHidden = true
        
        if Auth.auth().currentUser == nil {
            nameLabel.text = ""
            emailLabel.text = ""
            modeLabel.text = ""
            userTypeLabel.text = ""
            switchController.isHidden = true
            profileImage.isHidden = true
            lgnBtn.setTitle("Signup/Login", for: .normal)
        } else {
            observeDriversPassengers()
            lgnBtn.setTitle("Log out", for: .normal)
        }
        
        
    }
    
    func observeDriversPassengers() {
        
        DataService.instance.REF_USERS.observeSingleEvent(of: .value) { (_snapshot) in
            if let snapshot = _snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshot {
                    if snap.key == Auth.auth().currentUser?.uid {
                        self.modeLabel.isHidden = false
                        self.userTypeLabel.text = "Passenger"
                        guard let email = Auth.auth().currentUser?.email else { return }
                        self.emailLabel.text = email
                        
                    }
                }
            }
        }
        
        DataService.instance.REF_DRIVERS.observeSingleEvent(of: .value) { (_snapshot) in
            if let snapshot = _snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshot {
                    if snap.key == Auth.auth().currentUser?.uid {
                        self.userTypeLabel.text = "Driver"
                        self.modeLabel.text = snap.childSnapshot(forPath: "isOnline").value as! Bool ? "You are Online" : "You are offline"
                        self.modeLabel.isHidden = false
                        self.switchController.isHidden = false
                        guard let email = Auth.auth().currentUser?.email else { return }
                        self.emailLabel.text = email
                        let switchStatus = snap.childSnapshot(forPath: "isOnline").value as! Bool
                        self.switchController.isOn = switchStatus
                        
                    }
                }
                
            }
        }
    }
    
    // IBActions
    
    @IBAction func lgnBtnTapped(_ sender: Any) {
        if Auth.auth().currentUser == nil {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let loginVC = storyboard.instantiateViewController(withIdentifier: "loginVC") as? LoginVC else { return }
            present(loginVC, animated: true, completion: nil)
        } else {
            let firebaseAuth = Auth.auth()
            do {
                guard let email = Auth.auth().currentUser?.email else { return }
                try firebaseAuth.signOut()
                print("Successfully Logged user: \(email)")
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }

        }
    }
    
    
    @IBAction func switchToggleTapped(_ sender: Any) {
            self.modeLabel.text = switchController.isOn ? "You are Online" : "You are Offline"
        DataService.instance.REF_DRIVERS.child((Auth.auth().currentUser?.uid)!).updateChildValues(["isOnline" : switchController.isOn])
            appDelegate.MenuContainerVC.toggleLeftPanel()
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
