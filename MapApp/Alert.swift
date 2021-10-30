//
//  Alert.swift
//  MapApp
//
//  Created by Robert Miller on 30.10.2021.
//

import Foundation
import UIKit

extension UIViewController {
    
    func alertCreatePoint(text: @escaping (String) -> Void){
        let alertCP = UIAlertController(title: "Create new point", message: nil, preferredStyle: .alert)
        
        let alertOkButton = UIAlertAction(title: "Ok", style: .default) { _ in
            let tf = alertCP.textFields?.first
            guard let tfText = tf?.text else { return }
            text(tfText)
        }
        let alertCancelButoon = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertCP.addAction(alertOkButton)
        alertCP.addAction(alertCancelButoon)
        alertCP.addTextField { tf in tf.placeholder = "City, street house" }
        
        present(alertCP, animated: true, completion: nil)
        
    }
    
    func alertError(title: String, message: String){
        let alertErr = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertOkButton = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertErr.addAction(alertOkButton)
        
        present(alertErr, animated: true, completion: nil)
    }
    
    
}
