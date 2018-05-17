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
        let login = userEmailTextField.text!;
        let pwd = userPasswordTextField.text!;
        
        auth.checkAuth(
            
            login: login,
            pwd: pwd,
            result: { token -> Void in
                print(token) //TODO store it somewhere
                
                //UserDefaults.standard.set(true, forKey: "isUserLoggedIn");
                //UserDefaults.standard.synchronize();
                self.performSegue(withIdentifier: "loginToMap", sender: self)

            },
            error: { msg -> Void in
                let myAlert = UIAlertController(title:"Could not log in", message: msg, preferredStyle: UIAlertControllerStyle.alert);
                myAlert.addAction(UIAlertAction(title:"Ok", style:UIAlertActionStyle.default));
                self.present(myAlert, animated:true, completion:nil);
            }
        )
        
    }

}
