//
//  EditProfileViewController.swift
//  compa
//
//  Created by m2sar on 23/05/2018.
//  Copyright © 2018 m2sar. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController{
    
    
    @IBOutlet weak var updateUserImage: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateUIView()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func updateUIView(){
        self.updateUserImage.layer.cornerRadius = self.updateUserImage.frame.size.width / 2
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
            let vc = ctrl.storyboard?.instantiateViewController(withIdentifier: "mainView") as! MainViewController
            ctrl.present(vc, animated: true, completion: nil)
            UIViewController.removeSpinner(spinner: sv)
        }, error: { error in
            DispatchQueue.main.async(execute: {
                UIViewController.removeSpinner(spinner: sv)
                self.alert(error["message"] as! String)
                print(error)
            })
        })
        
    }
}
