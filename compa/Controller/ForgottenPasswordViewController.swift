///Users/m2sar/Documents/compa-ios/compa/Controller
//  ForgottenPasswordViewController.swift
//  compa
//
//  Created by m2sar on 02/06/2018.
//  Copyright © 2018 m2sar. All rights reserved.
//

import UIKit

class ForgottenPasswordViewController : UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    
    let userRep = UserRepository()
    
    @IBAction func returnTapped(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func sendTapped(_ sender: UIButton) {
        guard !emailField.text!.isEmpty else {
            DispatchQueue.main.async {
                self.alert("Yo hold up")
            }
            return
        }
        
        let email = emailField.text!
        
        userRep.resetPassword(
            email : email,
            result: { data in
                DispatchQueue.main.async {
                    self.alert("We have sent you an email with a resetted password", title: "Password Reset", handler: { ACTION in
                        self.dismiss(animated: true)
                    })
                }
            },
            error : { data in
                DispatchQueue.main.async {
                    self.alert("No account with this email was found")
                }
            }
        )
        
    }
}
