//
//  Alertable.swift
//  ride-along-development
//
//  Created by Alisher Abdukarimov on 1/22/18.
//  Copyright © 2018 Alisher Abdukarimov. All rights reserved.
//

import Foundation
import UIKit

protocol Alertable {}

extension Alertable where Self: UIViewController {
    func showAlert(_ message: String) {
        let alert = UIAlertController(title: "🙁", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
}
