//
//  ViewController.swift
//  compa
//
//  Created by m2sar on 12/04/2018.
//  Copyright © 2018 m2sar. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool){
        //self.performSegue(withIdentifier:"mainToMap", sender: self)
    }

    override func viewWillAppear(_ animated: Bool) {
        let mapView = self.storyboard?.instantiateViewController(withIdentifier: "mapView") as! MapViewController
        let token = UserDefaults.standard.value(forKey: "token")
        if(token != nil){
            self.present(mapView, animated: true, completion: nil)
        }
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier:"mainToLogin", sender: self)
    }

    @IBAction func registerButtonTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier:"mainToRegister", sender: self)
    }
}

