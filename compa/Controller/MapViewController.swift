//
//  MapController.swift
//  compa
//
//  Created by m2sar on 12/04/2018.
//  Copyright © 2018 m2sar. All rights reserved.
//

import UIKit
import MapKit

private let kUserAnnotationName = "kUserAnnotationName"

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UserDetailMapViewDelegate {
    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var searchBar: SearchTextField!
    
    var mapUpdateTimer: Timer?
    var locationUpdateTimer: Timer?
    
    let userRep = UserRepository()
    let locationRep = LocationRepository()
    let locationManager = CLLocationManager()
    static let regionRadius: CLLocationDistance = 1000
    static let distanceBetweenUpdates : Double = 10 //in meters
    var users : [User] = []
    var lastLocationUpdate : CLLocation?
    
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
        map.setCenter(map.userLocation.coordinate, animated: false)
        searchBar.itemSelectionHandler = { data, index in
            
            let user = data[index].user!
            
            if let location = user.lastLocation {
                
                self.map.setCenter(location.toCoordinate(), animated: true)
            
                let annotations : [UserAnnotation] = self.map.annotations as! [UserAnnotation]
            
                if let userAnnotation = annotations.first(where: {$0.user.id == user.id}) {
                    self.map.selectAnnotation(userAnnotation, animated: false)
                }
                
            }
            
        }
        
    }
    
    func startMapTimer() {
        
        let ctrl = self
        mapUpdateTimer?.invalidate()

        DispatchQueue.main.async {
            
            self.mapUpdateTimer = Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true) { _ in
                print("updating map")
                ctrl.userRep.getFriends (
                    result: { data in
                        
                        self.users = data
                        
                        DispatchQueue.main.async(execute: {
                     
                            let annotations = data.map {UserAnnotation(user:$0)}
                            self.map.removeAnnotations(self.map.annotations)
                            self.map.addAnnotations(annotations)
                        
                        })
                        
                        self.searchBar.filterItems(data.map {SearchTextFieldItem(title: $0.name, subtitle: $0.login, image: nil, user : $0)})
                    },

                    error: { error in
                    
                        if (ctrl.checkToken(error: error)) {
                            ctrl.alert(error["message"] as! String)
                        }
                    
                    }
                )
            
            }
            
            self.mapUpdateTimer!.fire()
        }
    }
    
    func startLocationTimer(){
        locationUpdateTimer?.invalidate()
        
        DispatchQueue.main.async {
            
            self.locationUpdateTimer = Timer.scheduledTimer(withTimeInterval: 30.0, repeats: true) { _ in
                self.locationManager.requestLocation()
            }
            
            self.locationUpdateTimer!.fire()
            
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
        map.setCenter(map.userLocation.coordinate, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if CLLocationManager.locationServicesEnabled() {
            switch status {
            case .restricted, .denied:
                self.alert("why not :(")
                break
                
            case .authorizedWhenInUse,.authorizedAlways:
                startLocationTimer()
                break
                
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
                break
            }
        
        }
        
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
 
        let ctrl = self
        
        if let location = locations.first {
            
            if(!UserDefaults.standard.bool(forKey: "ghostMode")) {
                
                if lastLocationUpdate == nil || abs(location.distance(from: lastLocationUpdate!)) > MapViewController.distanceBetweenUpdates {
                    
                    self.lastLocationUpdate = location
                    
                    let obj = Location(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, date: Date())
                    
                    locationRep.create(
                        object: obj,
                        result: { data in
                            print("updated location to back")
                        },
                        error: { error in
                            if (ctrl.checkToken(error: error)) {
                                ctrl.alert(error["message"] as! String)
                            }
                        }
                    )

                }
            }
            
        }

        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error){
        
        if !CLLocationManager.locationServicesEnabled() {
            self.alert("location services not enabled")
        }
        else {
           self.alert(error.localizedDescription)
        }
        
    }
    
    private func centerMapOnLocation(location: CLLocationCoordinate2D) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location, MapViewController.regionRadius, MapViewController.regionRadius)
        map.setRegion(map.regionThatFits(coordinateRegion), animated: true)
    }

    /*func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        centerMapOnLocation(location: userLocation.coordinate)
    }*/
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation { return nil }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: kUserAnnotationName)
        
        if annotationView == nil {
            annotationView = UserWishListAnnotationView(annotation: annotation, reuseIdentifier: kUserAnnotationName)
            (annotationView as! UserWishListAnnotationView).UserDetailDelegate = self
        } else {
            annotationView!.annotation = annotation
        }
        
        return annotationView
        
    }
    
    func detailsRequestedForUser(user: User) {
       
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "UserDetails", sender: nil)
        }
    }
    
    func dealWithTapped(user: User){
    
        let vc = storyboard?.instantiateViewController(withIdentifier: "FriendProfile") as! FriendProfileViewController
        vc.friendId = user.id
        vc.status = "Accepted"
        
         DispatchQueue.main.async {
            self.present(vc, animated: true, completion: nil)
        }
        
        
    }
    
    
     // Hide keyboard when touching the screen
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    
}



