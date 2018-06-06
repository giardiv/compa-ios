//
//  RegisterPageViewController.swift
//  compa
//
//  Created by m2sar on 21/04/2018.
//  Copyright © 2018 m2sar. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var userLoginTextField: UITextField!
    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    
    let auth: AuthenticationService = AuthenticationService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "registerToLogin", sender:self)
    }
    
    
    @IBAction func registerButtonTapped(_ sender: UIButton) {
        let userName = userNameTextField.text
        let userLogin = userLoginTextField.text
        let userEmail = userEmailTextField.text
        let userPassword = userPasswordTextField.text
        let userRepeatPassword = repeatPasswordTextField.text
        
        
        guard (!(userName?.isEmpty)!) || (!(userLogin?.isEmpty)!) || (!(userPassword?.isEmpty)!) || (!(userRepeatPassword?.isEmpty)!) else {
            self.alert("Fill me this pliz", title: "That's empty !", handler: nil)
            return
        }
        
        guard userPassword == userRepeatPassword else {
            self.alert("Try again pliz", title: "Wrong !", handler: nil)
            return
        }

        let dict = ["name" : userName!, "email" : userEmail!,  "login" : userEmail!, "password" : userPassword!]
        let ctrl  = self
        
        auth.register(
            
            credentials: dict,
            result: { token in
                
                UserDefaults.standard.set(token, forKey: "token");
                UserDefaults.standard.synchronize();

                DispatchQueue.main.async(execute: {
                    ctrl.alert("Registration is successful. Thank you!", title: "", handler: {ACTION in
                        self.dismiss(animated: true, completion: nil)
                    })
                })

            },
            error: { error in
                
                DispatchQueue.main.async(execute: {
                    ctrl.alert(error["message"] as! String)
                })
                
            }
        )
        
    }

}
