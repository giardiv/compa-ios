//
//  LoginViewController.swift
//  compa
//
//  Created by m2sar on 21/04/2018.
//  Copyright © 2018 m2sar. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    
    let auth: AuthenticationService = AuthenticationService()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func registerButtonTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "loginToRegister", sender: self)
    }

    @IBAction func loginButtonTapped(_ sender: UIButton) {
       
        guard (!(userEmailTextField.text!.isEmpty)) || (!(userPasswordTextField.text!.isEmpty)) else {
            alert("All fields are required")
            return
        }
        
        let login = userEmailTextField.text;
        let pwd = userPasswordTextField.text;
        
        let sv = UIViewController.displaySpinner(onView: self.view)
        
        auth.checkAuth(
            
            login: login!,
            pwd: pwd!,
            result: { token in
                
                UserDefaults.standard.set(token, forKey: "token");
                UserDefaults.standard.synchronize();
                DispatchQueue.main.async(execute: {
                    UIViewController.removeSpinner(spinner: sv)
                    self.performSegue(withIdentifier: "loginToMap", sender: self)
                })
            },
            error: { error in
                DispatchQueue.main.async(execute: {
                    UIViewController.removeSpinner(spinner: sv)
                    self.alert(error["message"] as! String)
                })
                
            }
        )
        
    }

}
