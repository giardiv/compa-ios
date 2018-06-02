//
//  EditProfileViewController.swift
//  compa
//
//  Created by m2sar on 23/05/2018.
//  Copyright © 2018 m2sar. All rights reserved.
//

import UIKit
import Photos

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    static let shared = EditProfileViewController()
    
    let repo = UserRepository()
    fileprivate var currentVC: UIViewController?
    
    //MARK: - Internal Properties
    var imagePickedBlock: ((UIImage) -> Void)?

    
    enum setPhotoType: String{
        case camera
        case photoLibrary
    }

    @IBOutlet weak var editNameField: UITextField!
    @IBOutlet weak var ghostMode: UISwitch!
    
    
    @IBOutlet var updateUserImage: UIImageView!
    
    //MARK: - Constants
    struct Constants {
        static let actionFileTypeHeading = "Update photo profile"
        static let actionFileTypeDescription = "Choose a filetype to add..."
        static let camera = "Camera"
        static let phoneLibrary = "Phone Library"
        
        static let alertForPhotoLibraryMessage = "App does not have access to your photos. To enable access, tap settings and turn on Photo Library Access."
        
        static let alertForCameraAccessMessage = "App does not have access to your camera. To enable access, tap settings and turn on Camera."
        
        
        static let settingsBtnTitle = "Settings"
        static let cancelBtnTitle = "Cancel"
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func openCameraButton(_ sender: Any) {
        print("in openCameraButton")
        
        /*self.updateUserImage.layer.cornerRadius = self.updateUserImage.frame.size.width
        self.updateUserImage.image = #imageLiteral(resourceName: "images") //TODO
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            var updateUserImage = UIImagePickerController()
            updateUserImage.delegate = self
            updateUserImage.sourceType = .photoLibrary;
            updateUserImage.allowsEditing = true
            self.present(updateUserImage, animated: true, completion: nil)
            
        }*/
        
        
        let actionSheet = UIAlertController(title: Constants.actionFileTypeHeading, message: Constants.actionFileTypeDescription, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: Constants.camera, style: .default, handler: { (action) -> Void in
            self.authorisationStatus(setPhotoTypeEnum: .camera, vc: self)
        }))
        
        actionSheet.addAction(UIAlertAction(title: Constants.phoneLibrary, style: .default, handler: { (action) -> Void in
            self.authorisationStatus(setPhotoTypeEnum: .photoLibrary, vc: self)
        }))
        
        actionSheet.addAction(UIAlertAction(title: Constants.cancelBtnTitle, style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    

    func authorisationStatus(setPhotoTypeEnum: setPhotoType, vc: UIViewController){
        
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            if setPhotoTypeEnum == setPhotoType.camera{
                print("avant open camera")
                openCamera()
            }
            if setPhotoTypeEnum == setPhotoType.photoLibrary{
                photoLibrary()
            }
        case .denied:
            print("permission denied")
            self.addAlertForSettings(setPhotoTypeEnum)
        case .notDetermined:
            print("Permission Not Determined")
            PHPhotoLibrary.requestAuthorization({ (status) in
                if status == PHAuthorizationStatus.authorized{
                    // photo library access given
                    print("access given")
                    if setPhotoTypeEnum == setPhotoType.camera{
                        self.openCamera()
                    }
                    if setPhotoTypeEnum == setPhotoType.photoLibrary{
                        self.photoLibrary()
                    }
                }else{
                    print("restriced manually")
                    self.addAlertForSettings(setPhotoTypeEnum)
                }
            })
        case .restricted:
            print("permission restricted")
            self.addAlertForSettings(setPhotoTypeEnum)
        default:
            break
        }
    }
    
    
    //MARK: - CAMERA PICKER
    //This function is used to open camera from the iphone and
    func openCamera(){
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self
            myPickerController.sourceType = .camera
            self.present(myPickerController, animated: true, completion: nil)
            
        }
    }
    
    //MARK: - PHOTO PICKER
    func photoLibrary(){
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self
            myPickerController.sourceType = .photoLibrary
            self.present(myPickerController, animated: true, completion: nil)
            
        }
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    
        let edit = info[UIImagePickerControllerOriginalImage] as?UIImage
        self.updateUserImage.contentMode = .scaleAspectFit
        self.updateUserImage.image = edit
        
        self.dismiss(animated: true, completion: nil)
        
        //let image_data = UIImagePNGRepresentation(ima)
        let body = NSMutableData()
        let file_image = "imgProfile.png"
        let mimetype = "image/png"
        
    }
    

    
    //MARK: - SETTINGS ALERT
    func addAlertForSettings(_ setPhotoTypeEnum: setPhotoType){
        var alertTitle: String = ""
        if setPhotoTypeEnum == setPhotoType.camera{
            alertTitle = Constants.alertForCameraAccessMessage
        }
        if setPhotoTypeEnum == setPhotoType.photoLibrary{
            alertTitle = Constants.alertForPhotoLibraryMessage
        }

        
        let cameraUnavailableAlertController = UIAlertController (title: alertTitle , message: nil, preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: Constants.settingsBtnTitle, style: .destructive) { (_) -> Void in
            let settingsUrl = NSURL(string:UIApplicationOpenSettingsURLString)
            if let url = settingsUrl {
                UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
            }
        }
        let cancelAction = UIAlertAction(title: Constants.cancelBtnTitle, style: .default, handler: nil)
        cameraUnavailableAlertController .addAction(cancelAction)
        cameraUnavailableAlertController .addAction(settingsAction)
        self.present(cameraUnavailableAlertController , animated: true, completion: nil)
    }

    
    
    
    //,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
    
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
    
    

    @IBAction func onCancelButtonTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }

    
    @IBAction func onLogOutButtonTapped(_ sender: UIButton) {
        let sv = UIViewController.displaySpinner(onView: self.view)
        let auth = AuthenticationService()
        let ctrl = self
        auth.logout(result: { data in
            UIViewController.removeSpinner(spinner: sv)
            UserDefaults.standard.removeObject(forKey: "token")
            UserDefaults.standard.synchronize()
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
