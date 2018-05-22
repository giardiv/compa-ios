//
//  ProfileViewController.swift
//  compa
//
//  Created by m2sar on 18/05/2018.
//  Copyright © 2018 m2sar. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var login: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    let list = ["Jean", "Franck", "Marc"]
    
    @IBOutlet weak var friendName: UILabel!
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
    
    //TableView
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ProfileTableViewCell  else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        //TODO récupéré la liste des friends de User
        //let friends = User.getFriends()[indexPath.row] ?
        //friends.username; user.image
        cell.friendName?.text = list[indexPath.row]
        cell.friendImage?.image = #imageLiteral(resourceName: "person-profile")
        
        return cell
    }
    //Fin Table
    
    func updateUIView() {
        self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width / 2
        //TODO initialisé en récupérant le login et l'image de profil de l'user connecter
        let curentUser =  User()
        self.profileImage.image = #imageLiteral(resourceName: "images")
        //self.profileImage.image = curentUser.profileImage
        self.login.text = curentUser.username
    }
    
    @IBAction func mapButtonTapped(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "profileToMap", sender: self)
    }
}
