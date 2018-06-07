//
//  ProfileViewController.swift
//  compa
//
//  Created by m2sar on 06/06/2018.
//  Copyright © 2018 m2sar. All rights reserved.
//

import UIKit
import MapKit

class ProfileViewController: UIViewController, MKMapViewDelegate {
    

    @IBOutlet weak var userProfileName: UILabel!
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var userProfileMap: MKMapView!
    
    let userRepositoty = UserRepository()
    let imageService = ImageService()
    let locationRepository = LocationRepository()
    
    override func viewWillAppear(_ animated: Bool) {
        let sv = UIViewController.displaySpinner(onView: self.view)
        let ctrl = self

        userRepositoty.getAuthUser(
            result: { user in
                if let img = user.imgUrl {
                  
                    self.imageService.downloadImage(
                        url: img,
                        successHandler: {data in
                            
                            DispatchQueue.main.async {
                                ctrl.userProfileImage.image = data
                                ctrl.userProfileName.text = user.name
                                UIViewController.removeSpinner(spinner: sv)
                            }
                            if let location = user.lastLocation {
                                
                                self.centerMapOnLocation(location: CLLocation(latitude: location.latitude, longitude: location.longitude))
                                self.locationRepository.getLocations(result: {data in
                                    
                                    DispatchQueue.main.async {
                                        
                                        self.createPolyline(data)
                                    }
                                    
                                }, error: {error in})
                                
                            }
                    },
                        errorHandler: {error in }
                    )
                }
               
            },

            error: {error in

                if( self.checkToken(error: error, spinner:sv)) {

                    UIViewController.removeSpinner(spinner: sv)
                    self.alert(error["message"] as! String)
                }
            }
        )
        
    }
    
    @IBAction func profileToMapTapped(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "profileToMap", sender: self)
    }
    
    let regionRadius: CLLocationDistance = 1000
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
        userProfileMap.setRegion(coordinateRegion, animated: true)
    }
    
    func createPolyline(_ locations: [Location]) {
        
        let polyline = MKPolyline(coordinates: locations.map(
        { return $0.toCoordinate() }), count: locations.count)
        userProfileMap.add(polyline)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let polylineReader = MKPolylineRenderer(overlay: overlay)
        polylineReader.strokeColor = UIColor.red
        polylineReader.lineWidth = 5
        
        return polylineReader
    }

}
