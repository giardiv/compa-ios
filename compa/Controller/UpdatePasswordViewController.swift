//
//  UpdatePasswordViewController.swift
//  compa
//
//  Created by m2sar on 04/06/2018.
//  Copyright © 2018 m2sar. All rights reserved.
//

import UIKit

class UpdatePasswordViewController : UIViewController {
    
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var newPasswordField: UITextField!
    
    let userRep = UserRepository()
    
    @IBAction func returnTapped(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func updateTapped(_ sender: UIButton) {
        
        guard (!(passwordField.text!.isEmpty)) || (!(newPasswordField.text!.isEmpty)) else {
            alert("All fields are required")
            return
        }
        
        let oldPwd = passwordField.text!
        let newPwd = newPasswordField.text!
        
        let sv = UIViewController.displaySpinner(onView: self.view)
        
        userRep.updatePassword(
            oldPwd: oldPwd,
            newPwd: newPwd,
            result: { data in
                
                DispatchQueue.main.async(execute: {
                    UIViewController.removeSpinner(spinner: sv)
                    self.alert("Your password has been successfully updated", title: "Password Update", handler: { ACTION in
                        let token = data["token"] as! String
                        UserDefaults.standard.set(token, forKey:"token")
                        self.dismiss(animated: true)
                    })
                })
                
                print(data)
            },
            error: { data in
                DispatchQueue.main.async(execute: {
                    UIViewController.removeSpinner(spinner: sv)
                    self.alert(data["message"] as! String, title:"Error")
                })
                
            })
        //Do the thang
    }
}

