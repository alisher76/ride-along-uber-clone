//
//  LoginVC.swift
//  ride-along-development
//
//  Created by Alisher Abdukarimov on 1/5/18.
//  Copyright © 2018 Alisher Abdukarimov. All rights reserved.
//

import UIKit
import Firebase

class LoginVC: UIViewController, UITextFieldDelegate, Alertable {
    
    // Outlets
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var usernameTextField: RoundedCornerTxtField!
    @IBOutlet weak var passwrodTextField: RoundedCornerTxtField!
    @IBOutlet weak var signInBtn: RoundedShadowButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.bindToKeyboard()
        usernameTextField.delegate = self
        passwrodTextField.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        self.view.addGestureRecognizer(tap)
    }
    
    
    
    @IBAction func closeBtnTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @IBAction func signInBtnTapped(_ sender: Any) {
        // Check to make sure text fields have values 
        if passwrodTextField.text != nil && usernameTextField.text != nil {
            signInBtn.animateButton(shouldLoad: true, withMessage: nil)
            self.view.endEditing(true)
            
            if let userName = usernameTextField.text, let passwd = passwrodTextField.text {
                Auth.auth().signIn(withEmail: userName, password: passwd, completion: { (user, error) in
                    if user != nil {
                        if let user = user {
                            if self.segmentControl.selectedSegmentIndex == 0 {
                                let userData = ["provider": user.providerID] as [String : Any]
                                DataService.instance.createDataBaseUser(withUid: user.uid, userData: userData, isDriver: false)
                            } else {
                                let userData = ["provider": user.providerID,
                                                "isDriver": true,
                                                "isOnline": false,
                                                "isOnTrip": false] as [String : Any]
                                DataService.instance.createDataBaseUser(withUid: user.uid, userData: userData, isDriver: true)
                            }
                        }
                        print("User authenticated successfully with Firebase")
                        self.dismiss(animated: true, completion: nil)
                        
                    } else if AuthErrorCode(rawValue: error!._code) == .invalidEmail {
                        // Handle error
                        print("Email invalid try again")
                        self.showAlert("Email invalid try again!")
                    } else if AuthErrorCode(rawValue: error!._code) == .wrongPassword {
                            print("Wrong password or email already in use")
                            self.showAlert("Email or Password is invalid")
                    } else {
                    
                        Auth.auth().createUser(withEmail: userName, password: passwd, completion: { (user, error) in
                           
                            if user == nil {
                                // Handle error
                                if let errorCode = AuthErrorCode(rawValue: error!._code) {
                                    switch errorCode {
                                    case .invalidEmail:
                                        self.showAlert("Email or Password invalid try again!")
                                    case .emailAlreadyInUse:
                                        print("Email already in use")
                                        self.showAlert("Email is in use!")
                                    case .weakPassword:
                                        self.showAlert("Weak Password, it has to be at least 6 characters!")
                                    default:
                                        self.showAlert("Sorry We could not your account!")
                                    }
                                }
                            } else {
                                
                                if let user = user {
                                    if self.segmentControl.selectedSegmentIndex == 0 {
                                        let userData = ["provider": user.providerID] as [String : Any]
                                        DataService.instance.createDataBaseUser(withUid: user.uid, userData: userData, isDriver: false)
                                    } else {
                                        let userData = ["provider": user.providerID,
                                                        "isDriver": true,
                                                        "isOnline": false,
                                                        "isOnTrip": false] as [String : Any]
                                        DataService.instance.createDataBaseUser(withUid: user.uid, userData: userData, isDriver: true)
                                    }
                                }
                                print("Successfully created user")
                                self.dismiss(animated: true, completion: nil)
                            }
                        })
                    }
                })
            }
        }
    }
}
