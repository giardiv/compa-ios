//
//  ProfileViewController.swift
//  compa
//
//  Created by m2sar on 18/05/2018.
//  Copyright © 2018 m2sar. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var login: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.updateUIView()
    }
    
    func updateUIView() {
        self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width / 2
        //TODO initialisé en récupérant le login et l'image de profil de l'user connecter
        let curentUser =  User(dictionary:[:])!
        self.profileImage.image = #imageLiteral(resourceName: "images")
        //self.profileImage.image = curentUser.profileImage
        self.login.text = curentUser.username
    }
    
    @IBAction func mapButtonTapped(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "profileToMap", sender: self)
    }
}
