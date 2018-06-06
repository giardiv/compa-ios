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

    override func viewWillAppear(_ animated: Bool) {
        let sv = UIViewController.displaySpinner(onView: self.view)

        self.userProfileImage.layer.cornerRadius = self.userProfileImage.frame.size.width / 2

        let ctrl = self

        userRepositoty.getAuthUser(
            result: { user in

                DispatchQueue.main.async(execute: {
                    ctrl.userProfileImage.image = #imageLiteral(resourceName: "images") //TODO
                    ctrl.userProfileName.text = user.name
                    UIViewController.removeSpinner(spinner: sv)
                })


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
    
}
