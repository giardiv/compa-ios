//
//  EditProfileViewController.swift
//  compa
//
//  Created by m2sar on 23/05/2018.
//  Copyright © 2018 m2sar. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    
    
    let repo = UserRepository()

    @IBOutlet weak var editNameField: UITextField!
    @IBOutlet weak var ghostMode: UISwitch!
    
    
    @IBOutlet var updateUserImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    @IBAction func openCameraButton(_ sender: Any) {
        /*print("in openCameraButton")
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let updateUserImage = UIImagePickerController()
            updateUserImage.delegate = self
            updateUserImage.sourceType = .camera
            updateUserImage.allowsEditing = true
            self.present(updateUserImage, animated: true, completion: nil)
        }*/
        
        /*if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            var imagePicker = UIImagePickerController()
            updateUserImage.delegate = self
            updateUserImage.sourceType = .photoLibrary;
            updateUserImage.allowsEditing = true
            self.presentViewController(updateUserImage, animated: true, completion:nil)
        }*/
        
    }

    
    
    
    override func viewWillAppear(_ animated: Bool) {
        let sv = UIViewController.displaySpinner(onView: self.view)
        //self.updateUserImage.layer.cornerRadius = self.updateUserImage.frame.size.width / 2
        //TODO initialisé en récupérant le login et l'image de profil de l'user connecté
        
        let ctrl = self
        
        repo.getAuthUser(
            result: { user in
                DispatchQueue.main.async(execute: {
                    //ctrl.updateUserImage.setBackgroundImage(#imageLiteral(resourceName: "images"), for: UIControlState.normal)//TODO
                    ctrl.editNameField.placeholder = user.name
                    ctrl.ghostMode.setOn(user.ghostMode, animated: false)
                    UIViewController.removeSpinner(spinner: sv)
                })
                
        },
            error: {error in
                if( self.checkToken(error: error, spinner:sv) ) {
                    DispatchQueue.main.async(execute: {
                        UIViewController.removeSpinner(spinner: sv)
                        self.alert(error["message"] as! String)
                    })
                    
                }
        })
    }
    
    @IBAction func updateUserImageTapped(_ sender: Any) {
        print("todo")
    }
    

    @IBAction func onCancelButtonTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }

    
    @IBAction func onLogOutButtonTapped(_ sender: UIButton) {
        let sv = UIViewController.displaySpinner(onView: self.view)
        let auth = AuthenticationService()
        let ctrl = self
        auth.logout(result: { data in
            UIViewController.removeSpinner(spinner: sv)
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let mainView: UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "mainView")
            ctrl.present(mainView, animated: true, completion: nil)
        }, error: { error in
            DispatchQueue.main.async(execute: {
                UIViewController.removeSpinner(spinner: sv)
                self.alert(error["message"] as! String)
            })
        })
        
    }
}
