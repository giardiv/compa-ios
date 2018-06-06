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
    
    var userRefreshTimer: Timer?
    var locationUpdateTimer: Timer?
    
    let userRep = UserRepository()
    let locationRep = LocationRepository()
    let imageService = ImageService()
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
                else{
                    
                }
                
            }
            
        }
        
    }
    
    private func startUserRefreshTimer() {
        
        let ctrl = self
        userRefreshTimer?.invalidate()

        DispatchQueue.main.async {
            
            self.userRefreshTimer = Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true) { _ in
               
                ctrl.userRep.getFriends (
                    result: { data in
                        
                        let group = DispatchGroup()
                  
                        for user in data {
                            
                            if let img = user.imgUrl {
                                
                                group.enter()
                                self.imageService.downloadImage(
                                    url: img,
                                    successHandler: {data2 in
                                        user.image = data2
                                        group.leave()
                                    },
                                    errorHandler: {error in }
                                )
                                
                            }
                        }
                        
                        group.notify(queue: DispatchQueue.main) {
                            self.users = data
                            
                            //refresh map
                            let users = self.users.filter { $0.lastLocation != nil }
                            let annotations = users.map {UserAnnotation(user:$0)}
                            self.map.removeAnnotations(self.map.annotations)
                            self.map.addAnnotations(annotations)
                            
                            //refresh search bar
                            self.searchBar.filterItems(self.users.map {
                                return SearchTextFieldItem(title: $0.name, subtitle: $0.login, image: $0.image, user : $0)
                            })

                        }
                       
                    },

                    error: { error in
                    
                        if (ctrl.checkToken(error: error)) {
                            ctrl.alert(error["message"] as! String)
                        }
                    
                    }
                )
            
            }
            
            self.userRefreshTimer!.fire()
        }
    }
    

    private func startLocationTimer(){
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
                ctrl.startUserRefreshTimer()
                
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
        userRefreshTimer?.invalidate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //createPolyline(mapView: map)
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
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation { return nil }

        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: kUserAnnotationName)
        
        if annotationView == nil {
            annotationView = UserAnnotationView(annotation: annotation, reuseIdentifier: kUserAnnotationName)
            (annotationView as! UserAnnotationView).UserDetailDelegate = self
        } else {
            annotationView!.annotation = annotation
        }
        
        let annotation = annotation as! UserAnnotation
        annotationView?.image = (annotation.user.image)?.resized(newWidth: 20)
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


extension UIImage {
    
    func resized(newWidth: CGFloat) -> UIImage? {
        let scale = newWidth / self.size.width
        let newHeight = self.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width:newWidth, height:newHeight))
        self.draw(in: CGRect(x:0, y:0, width:newWidth, height:newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    func maskImage(mask:UIImage) ->UIImage {
        
        let imageReference = self.cgImage
        let maskReference = mask.cgImage!
        
        let imageMask = CGImage(maskWidth: maskReference.width,
                                height: maskReference.height,
                                bitsPerComponent: maskReference.bitsPerComponent,
                                bitsPerPixel: maskReference.bitsPerPixel,
                                bytesPerRow: maskReference.bytesPerRow,
                                provider: maskReference.dataProvider!,
                                decode: nil,
                                shouldInterpolate: true)
        
        let maskedReference = imageReference!.masking(imageMask!)
        let maskedImage = UIImage.init(cgImage:maskedReference!)
        return maskedImage
    }
}


