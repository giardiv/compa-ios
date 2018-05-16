//
//  MapController.swift
//  compa
//
//  Created by m2sar on 12/04/2018.
//  Copyright © 2018 m2sar. All rights reserved.
//

import UIKit
import MapKit


class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    let regionRadius: CLLocationDistance = 1000
    let locationManager = CLLocationManager()
    @IBOutlet weak var map: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        map.showsUserLocation = true
        locationManager.delegate = self
        map.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        
        let locations = User.getMockLocationsFor(CLLocation(latitude:51.509865, longitude:-0.118092))
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        
        for (date, location) in locations {
    
            let annotation = MKPointAnnotation()
            annotation.coordinate = location.coordinate
            annotation.title = dateFormatter.string(from: date)
            map.addAnnotation(annotation)
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
   /* func mapView(aMapView: MKMapView!, viewForAnnotation annotation: CustomMapPinAnnotation!) -> MKAnnotationView! {
        
    }*/
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
            case .restricted, .denied:
                alert("why not :(")
                break
            
            case .authorizedWhenInUse,.authorizedAlways:
                locationManager.requestLocation()
                break
            
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
                break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        print("update location")
        print(locations)
        //centerMapOnLocation(location: locations[locations.count], regionRadius: regionRadius)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error){
        print("failed update location")
        alert(error.localizedDescription)
    }
    
    private func alert(_ userMessage:String, handler: ((UIAlertAction) -> Void)? = nil){
        let myAlert = UIAlertController(title:"Alert", message:userMessage, preferredStyle: UIAlertControllerStyle.alert);
        myAlert.addAction(UIAlertAction(title:"Ok", style:UIAlertActionStyle.default, handler: handler));
        self.present(myAlert, animated:true, completion:nil);
    }
    
    private func centerMapOnLocation(location: CLLocation, regionRadius: CLLocationDistance) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius, regionRadius)
        map.setRegion(coordinateRegion, animated: true)
    }
    
}

