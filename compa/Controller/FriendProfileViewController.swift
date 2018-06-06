//
//  FriendProfileViewController.swift
//  compa
//
//  Created by m2sar on 23/05/2018.
//  Copyright © 2018 m2sar. All rights reserved.
//

import UIKit
import MapKit

class FriendProfileViewController: UIViewController, MKMapViewDelegate {
       
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var friendName: UILabel!
    @IBOutlet weak var friendLastLocation: UILabel!
    @IBOutlet weak var friendImage: UIImageView!
    @IBOutlet weak var buttonStatus: UIButton!
    
    let imageService = ImageService()
    let userRepository = UserRepository()
    let locationRepository = LocationRepository()
    let friendshipRepo = FriendshipRepository()
    var friendId = ""
    var status = ""
    var friend:User?
    
    var friendLocations : [Location] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool){
        let sv = UIViewController.displaySpinner(onView: self.view)
        let ctrl = self

        userRepository.get(identifier: friendId, result: { user in
            DispatchQueue.main.async(execute: {
                self.friend = user
                ctrl.friendImage.image = #imageLiteral(resourceName: "images") //TODO
                ctrl.friendName.text = user.name
                if let location = user.lastLocation {
                   ctrl.friendLastLocation.text = String(location.latitude)
                }
              ctrl.buttonStatus?.setTitle("▾ " + ctrl.status, for: UIControlState.normal)
                    UIViewController.removeSpinner(spinner: sv)

                
                
                
                if let img = user.imgUrl {
                    print(img)
                    self.imageService.downloadImage(
                        url: img,
                        successHandler: {data in
                            DispatchQueue.main.async {
                                ctrl.friendImage.image = data
                                ctrl.friendImage.layer.cornerRadius = ctrl.friendImage.frame.size.width / 2 //DOESNT WORK
                            }
                        },
                        errorHandler: {error in
                        }
                    )
                }

                ctrl.buttonStatus?.setTitle("▾ " + ctrl.status, for: UIControlState.normal)
                UIViewController.removeSpinner(spinner: sv)

                let initialLocation = CLLocation(latitude: user.lastLocation!.latitude, longitude: user.lastLocation!.longitude)
                self.centerMapOnLocation(location: initialLocation)
                
                self.locationRepository.getFriendLocations(identifier: self.friendId, result: {data in
                    self.friendLocations = data
                    DispatchQueue.main.async(execute: {
                        self.createPolyline(data)
                    })
                }, error: {error in})
            })
        }, error: {error in})

    }
    
    let regionRadius: CLLocationDistance = 1000
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }

    @IBAction func onCancelButtonTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func displayActionSheet(_ sender: Any) {
        let ctrl = self
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .default, handler: { (alert: UIAlertAction!) -> Void in
            let sv = UIViewController.displaySpinner(onView: self.view)
            ctrl.friendshipRepo.deleteFriendship(
                friendId: ctrl.friendId,
                result: { data in
                    ctrl.alert((ctrl.friendName?.text)! + " is deleted", handler: {Void in
                        ctrl.dismiss(animated: true, completion: nil)
                        UIViewController.removeSpinner(spinner: sv)
                    })
                }, error: { error in
                    ctrl.alert(error["message"] as! String)
                    UIViewController.removeSpinner(spinner: sv)
                }
            )
        })
        
        let blockAction = UIAlertAction(title: "Block", style: .default, handler: { (alert: UIAlertAction!) -> Void in
            let sv = UIViewController.displaySpinner(onView: self.view)
            ctrl.friendshipRepo.blockUser(
                friendId: ctrl.friendId,
                result: { data in
                    ctrl.alert((ctrl.friendName?.text)! + " is blocked !", handler: {Void in
                        ctrl.dismiss(animated: true, completion: nil)
                        UIViewController.removeSpinner(spinner: sv)
                    })
                }, error: { error in
                    ctrl.alert(error["message"] as! String)
                    UIViewController.removeSpinner(spinner: sv)
                }
            )
        })
        
        let rejectRequestAction = UIAlertAction(title: "Reject", style: .default, handler: { (alert: UIAlertAction!) -> Void in
            let sv = UIViewController.displaySpinner(onView: self.view)
            ctrl.friendshipRepo.rejectFriendshipRequest(
                friendId: ctrl.friendId,
                result: { data in
                    ctrl.alert("The friend request has been rejected :)", handler: {Void in
                        ctrl.dismiss(animated: true, completion: nil)
                        UIViewController.removeSpinner(spinner: sv)
                    })
                }, error: { error in
                    ctrl.alert(error["message"] as! String)
                    UIViewController.removeSpinner(spinner: sv)
                }
            )
        })
        
        let confirmRequestAction = UIAlertAction(title: "Confirm", style: .default, handler: { (alert: UIAlertAction!) -> Void in
            let sv = UIViewController.displaySpinner(onView: self.view)
            ctrl.friendshipRepo.confirmFriendshipRequest(
                friendId: ctrl.friendId,
                result: { data in
                    ctrl.alert("You are now friend with " + (ctrl.friendName?.text)! + " !")
                    ctrl.buttonStatus?.setTitle("▾ Accepted", for: UIControlState.normal)
                    UIViewController.removeSpinner(spinner: sv)
                }, error: { error in
                    ctrl.alert(error["message"] as! String)
                    UIViewController.removeSpinner(spinner: sv)
                }
            )
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (alert: UIAlertAction!) -> Void in
        })
        
        
        if(self.buttonStatus?.titleLabel?.text == "▾ Awaiting") {
            optionMenu.addAction(confirmRequestAction)
            optionMenu.addAction(rejectRequestAction)
        } else if (self.buttonStatus?.titleLabel?.text == "▾ Accepted") {
            optionMenu.addAction(blockAction)
            optionMenu.addAction(deleteAction)
        }
        
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    func createPolyline(_ locations: [Location]) {
        
        let polyline = MKPolyline(coordinates: locations.map(
            { return $0.toCoordinate() }), count: locations.count)
        mapView.add(polyline)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let polylineReader = MKPolylineRenderer(overlay: overlay)
        polylineReader.strokeColor = UIColor.red
        polylineReader.lineWidth = 5

        return polylineReader
    }
}
