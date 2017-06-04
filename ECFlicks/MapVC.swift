//
//  MapVC.swift
//  ECFlicks
//
//  Created by EricDev on 6/2/17.
//  Copyright © 2017 EricDev. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class MapVC: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    let initialAuthorization = CLLocationManager.authorizationStatus()
    let regionRadius: CLLocationDistance = 1600
    var coordinateRegion: MKCoordinateRegion!
    @IBOutlet weak var segmentedController: UISegmentedControl!
    @IBOutlet weak var mapButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationAuthenticationStatus()
        configureView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
        
        centerMapOnLocation()
        
    }
    

    @IBAction func segmentedControldidChange(_ sender: UISegmentedControl) {
        
        mapView.removeAnnotations(mapView.annotations)
        requestLocations()
        
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let circleRenderer = MKCircleRenderer(overlay: overlay)
        circleRenderer.fillColor = UIColor.black
        circleRenderer.alpha = 0.05
        
        return circleRenderer
    }
    
    @IBAction func mapViewButtonClicked(_ sender: UIButton) {
        
        centerMapOnLocation()
        
    }
    
    func requestLocations() {
        
        if currentLocation != nil {
            
            let request = MKLocalSearchRequest()
            if segmentedController.selectedSegmentIndex == 0 {
                
                request.naturalLanguageQuery = "Theaters"
                
            } else if segmentedController.selectedSegmentIndex == 1 {
                
                request.naturalLanguageQuery = "Restaurants"
                
            } else if segmentedController.selectedSegmentIndex == 2 {
                
                request.naturalLanguageQuery = "Drink"
                
            }
            
            request.region = mapView.region
            
            let search = MKLocalSearch(request: request)
            search.start { response, error in
                guard let response = response else {
                    print("There was an error searching for: \(String(describing: request.naturalLanguageQuery)) error: \(String(describing: error))")
                    return
                }
                
                for item in response.mapItems {
                    let annotation = TheaterAnnotation(item: item)
                    self.mapView.addAnnotation(annotation)
                }
            }
        }
       
        
    }
    
    func showCircle(coordinate: CLLocationCoordinate2D, radius: CLLocationDistance) {
        mapView.removeOverlays(mapView.overlays)
        let circle = MKCircle(center: coordinate, radius: radius)
        mapView.add(circle)
   
    }
    
    func centerMapOnLocation() {
        
        mapView.setUserTrackingMode( MKUserTrackingMode.follow, animated: true)
        if currentLocation != nil {
            
            coordinateRegion = MKCoordinateRegionMakeWithDistance(currentLocation.coordinate, regionRadius * 3.0, regionRadius * 3.0)
            mapView.setRegion(coordinateRegion, animated: true)
            showCircle(coordinate: CLLocationCoordinate2DMake(currentLocation.coordinate.latitude, currentLocation.coordinate.longitude), radius: regionRadius)
            
        }
        requestLocations()
        
        
    }
    
    func locationAuthenticationStatus() {
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            
            currentLocation = locationManager.location
            Location.sharedInstance.latitude = currentLocation.coordinate.latitude
            Location.sharedInstance.longitude = currentLocation.coordinate.longitude
            

        } else if CLLocationManager.authorizationStatus() == .denied {
            
            if let url = NSURL(string:UIApplicationOpenSettingsURLString) {
                
                UIApplication.shared.open(url as URL)
                
            }
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status != initialAuthorization {
            locationAuthenticationStatus()
        }
    }

    func configureView(){
        
        mapView.showsScale = true
        mapView.showsCompass = true
        mapButton.tintColor = UIColor(red: 64.0/255.0, green: 224.0/255.0, blue: 208.0/255.0, alpha: 1)
        mapView.delegate = self
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startMonitoringSignificantLocationChanges()
        
        navigationController?.navigationBar.barTintColor = UIColor.black
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
    }

}

extension UIViewController: MKMapViewDelegate {
    
    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? TheaterAnnotation {
            let identifier = "pin"
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
                as? MKPinAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
            }
            return view
        }
        return nil
    }
    
    public func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                        calloutAccessoryControlTapped control: UIControl) {
        let location = view.annotation as! TheaterAnnotation
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        location.mapItem().openInMaps(launchOptions: launchOptions)
    }
}
