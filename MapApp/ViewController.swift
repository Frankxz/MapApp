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
    
    @IBOutlet weak var distanceLabel: UILabel!
    private var annotationList = [MKPointAnnotation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
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
        for index in 0...annotationList.count - 2 {
            configureDirection(startPoint: annotationList[index].coordinate, endPoint: annotationList[index + 1].coordinate)
        }
    }
    
    @objc func resetPoints(){
        mapView.removeOverlays(mapView.overlays)
        mapView.removeAnnotations(mapView.annotations)
        annotationList.removeAll()
        resetButton.isHidden = true
        buildButton.isHidden = true
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

// MARK: - configuring directions
extension ViewController {
   
    private func configureDirection(startPoint: CLLocationCoordinate2D, endPoint: CLLocationCoordinate2D){
        
        let startPoint = MKPlacemark(coordinate: startPoint)
        let endPoint = MKPlacemark(coordinate: endPoint)
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: startPoint)
        request.destination = MKMapItem(placemark: endPoint)
        request.transportType = .walking
        request.requestsAlternateRoutes = true
        
        let direction = MKDirections(request: request)
        direction.calculate { [self] response, error in
            if let error = error {
                print(error)
                alertError(title: "Error", message: error.localizedDescription)
                return
            }
            
            guard let response = response else {
                alertError(title: "Error", message: "Route not available")
                return
            }
            
            var distance: CLLocationDistance = .zero
            
            var optimalRoute = response.routes[0]
            for route in response.routes {
                optimalRoute = (route.distance < optimalRoute.distance) ? route : optimalRoute
                distance += optimalRoute.distance
            }
            distanceLabel.text = "\(Double(distance))"
            self.mapView.addOverlay(optimalRoute.polyline)
        }
    }
}

extension ViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        renderer.strokeColor = .orange
        return renderer
    }
}
