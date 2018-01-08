//
//  DataService.swift
//  ride-along-development
//
//  Created by Alisher Abdukarimov on 1/6/18.
//  Copyright © 2018 Alisher Abdukarimov. All rights reserved.
//

import Foundation
import Firebase

let DataBase_BASE = Database.database().reference()

class DataService {
    
    static let instance = DataService()
    
    private var _REF_BASE = DataBase_BASE
    private var _REF_USERS = DataBase_BASE.child("users")
    private var _REF_DRIVERS = DataBase_BASE.child("drivers")
    private var _REF_TRIPS = DataBase_BASE.child("trips")
    
    
    var REF_BASE: DatabaseReference {
        return _REF_BASE
    }
    
    var REF_USERS: DatabaseReference {
        return _REF_USERS
    }
    
    var REF_DRIVERS: DatabaseReference {
        return _REF_DRIVERS
    }
    
    var REF_TRIPS: DatabaseReference {
        return _REF_TRIPS
    }
    
    // MARK: Create DataBase User Method
    func createDataBaseUser(withUid uid: String, userData: Dictionary<String, Any>, isDriver: Bool) {
        if isDriver {
            REF_DRIVERS.child(uid).updateChildValues(userData)
        } else {
            REF_USERS.child(uid).updateChildValues(userData)
        }
    }
    
    
}

