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
    
    @IBOutlet weak var searchBar: UISearchBar!
    let regionRadius: CLLocationDistance = 10000
    let locationManager = CLLocationManager()
    @IBOutlet weak var map: MKMapView!
    
    let userRep = UserRepository()
    let locationRep = LocationRepository()
    
    static let dateFormatter = { () -> DateFormatter in
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        return dateFormatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        map.showsUserLocation = true
        locationManager.delegate = self
        map.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    
    weak var mapUpdateTimer: Timer?
    weak var locationUpdateTimer: Timer?
    
    func startMapTimer() {
        let ctrl = self
        mapUpdateTimer?.invalidate()
        
        mapUpdateTimer = Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true) { [weak self] _ in
            ctrl.userRep.getFriends (
                result: { data in
                    DispatchQueue.main.async(execute: {
                        print(data)
                        for user in data {
                            
                            let lastLocation = CLLocationCoordinate2D(latitude: user.lastLocation.latitude, longitude: user.lastLocation.longitude)
                            
                            print(lastLocation)
                            let annotation = MKPointAnnotation()
                            annotation.coordinate = lastLocation
                            annotation.title = user.name
                            ctrl.map.addAnnotation(annotation)
                        }
                        
                    })
                },

                error: {error in
                    
                    if (ctrl.checkToken(error: error)) {
                        ctrl.alert(error["message"] as! String)
                    }
                    
                }
            )
            
        }
        
        mapUpdateTimer?.fire() //Check if it works
    }
    
    func startLocUpdateTimer(){
        let ctrl = self
        locationUpdateTimer?.invalidate()
        
        if(!UserDefaults.standard.bool(forKey: "ghostMode")) {
            print("not ghosted")
            
            if let location = locationManager.location {
                
                let obj = Location(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, date: Date())
                
                locationUpdateTimer = Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true) { [weak self] _ in
                    ctrl.locationRep.create(
                        object: obj,
                        result: { data in
                            print("updated location heto")
                        },
                        error: { error in
                            if (ctrl.checkToken(error: error)) {
                                ctrl.alert(error["message"] as! String)
                            }
                        }
                    )
                    
                }
                
                locationUpdateTimer?.fire() //Check if it works
            }
     
        }
   
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let ctrl = self
        
        userRep.getAuthUser(
            result: { user in
                
                UserDefaults.standard.set(user.ghostMode, forKey: "ghostMode");
                UserDefaults.standard.synchronize();
                ctrl.startMapTimer()
                
            },
            
            error: {error in
                if( self.checkToken(error: error) ) {
                    DispatchQueue.main.async(execute: {
                        self.alert(error["message"] as! String)
                    })
                }
            }
        )
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        mapUpdateTimer?.invalidate()
    }
    
    @IBAction func centerTapped(_ sender: Any) {
        map.setCenter(CLLocationCoordinate2D(latitude: map.userLocation.coordinate.latitude, longitude: map.userLocation.coordinate.longitude), animated: false)
    }
    
    /*func test(){
        
        let sourceLocation = CLLocationCoordinate2D(latitude: 40.759011, longitude: -73.984472)
        let sourcePlacemark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let sourceAnnotation = MKPointAnnotation()
        if let location = sourcePlacemark.location {
            sourceAnnotation.coordinate = location.coordinate
        }
        
        
        let destinationLocation = CLLocationCoordinate2D(latitude: 40.748441, longitude: -73.985564)
        let destinationPlacemark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        let destinationAnnotation = MKPointAnnotation()
        if let location = destinationPlacemark.location {
            destinationAnnotation.coordinate = location.coordinate
        }
        
        //self.map.showAnnotations([sourceAnnotation,destinationAnnotation], animated: true )
        
        let directionRequest = MKDirectionsRequest()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .automobile
        let directions = MKDirections(request: directionRequest)
        
        directions.calculate {
            (response, error) -> Void in
            
            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                }
                
                return
            }
            
            let route = response.routes[0]
            self.map.add((route.polyline), level: MKOverlayLevel.aboveRoads)
            
            let rect = route.polyline.boundingMapRect
            self.map.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
        }
        
    }*/
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /*func mapView(aMapView: MKMapView!, viewForAnnotation annotation: CustomMapPinAnnotation!) -> MKAnnotationView! {
        
    }*/
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
            case .restricted, .denied:
                self.alert("why not :(")
                break
            
            case .authorizedWhenInUse,.authorizedAlways:
                locationManager.requestLocation()
                break
            
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
                break
        }
    }

    /*func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        if(!locations.isEmpty) {
            centerMapOnLocation(location: locations[locations.count-1], regionRadius: regionRadius)
            
        }
        
    }*/
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error){
        print("failed update location")
        self.alert(error.localizedDescription)
    }
    
    private func centerMapOnLocation(location: CLLocation, regionRadius: CLLocationDistance) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius, regionRadius)
        map.setRegion(coordinateRegion, animated: true)
    }
    
}

