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

}
