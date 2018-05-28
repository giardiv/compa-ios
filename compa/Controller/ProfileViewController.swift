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
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var newFriendUsername: UITextField!
    
    let repo = UserRepository()
    
    var userArray : [User] = []
    
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
        return userArray.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ProfileTableViewCell  else {
            fatalError("not sure what's happening.")
        }
        
        cell.friendName?.text = userArray[indexPath.row].name
        cell.friendImage?.image = #imageLiteral(resourceName: "person-profile") //TODO
        
        return cell
    }
    
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedFriend = userArray[indexPath.row]
        let vc = FriendProfileViewController()
        vc.friendId = selectedFriend.id
        DispatchQueue.main.async(execute: {
            self.performSegue(withIdentifier: "profileToFriend", sender: self)
        })


    }

    
    //Fin Table
    
    func updateUIView() {
        let sv = UIViewController.displaySpinner(onView: self.view)
        self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width / 2
        //TODO initialisé en récupérant le login et l'image de profil de l'user connecté

        let ctrl = self
        
        repo.getAuthUser(result: {user in
    
            DispatchQueue.main.async(execute: {
                ctrl.profileImage.image = #imageLiteral(resourceName: "images") //TODO
                ctrl.login.text = user.name
                
            })
            
        })
     
        repo.getFriends { data in
            //check error
            self.userArray = data
    
            DispatchQueue.main.async(execute: {
                self.table.reloadData()
                UIViewController.removeSpinner(spinner: sv)
            })
            
        }
        
        
    }
    
    @IBAction func addFriendButtonTapped(_ sender: UIBarButtonItem) {
        //TODO tester si le field n'est pas vide, envoyer une requète en base pour ajouter le nouvelle amis. En param user.login, friendUsername.
        //Si tout est bon afficher une popup "votre demande d'ami à bien été envoyer."
        //Sinon afficher une popup "utilisateur introuvable, veuillez réesayer."
        let friendUsername = self.newFriendUsername?.text
    }
    
    @IBAction func mapButtonTapped(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "profileToMap", sender: self)
    }
}
