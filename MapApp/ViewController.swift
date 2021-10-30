//
//  ViewController.swift
//  MapApp
//
//  Created by Robert Miller on 30.10.2021.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
   
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var buildButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    
    private var annotationList = [MKPointAnnotation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildButton.isHidden = true
        resetButton.isHidden = true
        
        addButton.addTarget(self, action: #selector(createPoint), for: .touchUpInside)
        buildButton.addTarget(self, action: #selector(buildRoutes), for: .touchUpInside)
        resetButton.addTarget(self, action: #selector(resetPoints), for: .touchUpInside)
    }
    
    @objc func createPoint(){
        alertCreatePoint { text in
            self.configurePoint(with: text)
        }
    }
    
    @objc func buildRoutes(){
        print("Routes builded")
    }
    
    @objc func resetPoints(){
        print("Points reseted")
    }
    
}

// MARK: - configuring points

extension ViewController {
    private func configurePoint(with adress: String){
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(adress) { [self] placemarks, error in
            if let error = error {
                print(error)
                alertError(title: "Error", message: error.localizedDescription)
            }
            
            guard let placemarks = placemarks else { return }
            let placemark = placemarks.first
            
            let annotation = MKPointAnnotation()
            annotation.title = adress
            guard let placemarkLocation = placemark?.location else { return }
            annotation.coordinate = placemarkLocation.coordinate
            
            annotationList.append(annotation)
            if annotationList.count > 2 {
                buildButton.isHidden = false
                resetButton.isHidden = false
            }
            
            mapView.showAnnotations(annotationList, animated: true)
        }
    }
}
