//
//  PassengerAnnotation.swift
//  ride-along-development
//
//  Created by Alisher Abdukarimov on 1/17/18.
//  Copyright © 2018 Alisher Abdukarimov. All rights reserved.
//

import Foundation
import MapKit


class PassengerAnnotation: NSObject, MKAnnotation {
    dynamic var coordinate: CLLocationCoordinate2D
    var key: String
    
    init(coordinate: CLLocationCoordinate2D, key: String) {
        self.coordinate = coordinate
        self.key = key
        super.init()
    }
}
