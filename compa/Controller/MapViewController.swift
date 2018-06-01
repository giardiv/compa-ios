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
    
    let userRep = UserRepository()
    let locationRep = LocationRepository()
    let locationManager = CLLocationManager()
    let regionRadius: CLLocationDistance = 10000
    var lastUpdatedTime = Date()
    var users : [User] = []
    
    var selectedUser: User?
    
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
        
        
        searchBar.itemSelectionHandler = { data, index in
            
            let user = data[index].user!
            
            if let location = user.lastLocation {
                
                let coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
                
                self.map.setCenter(coordinate, animated: true)
                
                for annotation in self.map.annotations {
                    if annotation.coordinate.latitude == coordinate.latitude &&
                        annotation.coordinate.longitude == coordinate.longitude {
                        self.map.selectAnnotation(annotation, animated: false)
                 
                    }
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
                
                locationManager.requestLocation()
                break
                
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
                break
            }
        
        }
        
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        
        
        let ctrl = self
        if let location = locations.last {
            print(location)
            if(Int(self.lastUpdatedTime.timeIntervalSinceNow) > 15){
                
                self.lastUpdatedTime = Date()
                
                if(!UserDefaults.standard.bool(forKey: "ghostMode")) {
                    print("not ghosted")
                    
                    let obj = Location(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, date: Date())
                    
                    locationRep.create(
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
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location, regionRadius, regionRadius)
        map.setRegion(map.regionThatFits(coordinateRegion), animated: true)
    }

    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        centerMapOnLocation(location: userLocation.coordinate)
    }
    
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
        self.selectedUser = user
        
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


