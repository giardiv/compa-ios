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
    @IBOutlet weak var search: SearchTextField!
    
    let repo = UserRepository()
    
    var userArray : [User] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        
        search.theme.bgColor = UIColor.white.withAlphaComponent(1)
        search.theme.borderColor = UIColor.black.withAlphaComponent(0.5)
        
        search.userStoppedTypingHandler = {
            if let criteria = self.search.text {
                if criteria.characters.count > 1 {
                    
                    self.search.showLoadingIndicator()
                    
                    self.repo.search(
                        text: criteria,
                        result: { data in
                            
                            let results = data.map { SearchTextFieldItem(title: $0.name, subtitle: $0.login, image: nil, user:$0) }
                            
                            DispatchQueue.main.async {
                                self.search.filterItems(results)
                                self.search.stopLoadingIndicator()
                            }
                    },
                        
                        error:{ error in
                            
                            DispatchQueue.main.async {
                                self.search.filterItems([])
                            }
                    }
                    )
                    
                }
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let sv = UIViewController.displaySpinner(onView: self.view)
        self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width / 2
        //TODO initialisé en récupérant le login et l'image de profil de l'user connecté
        
        let ctrl = self
        
        repo.getAuthUser(
            result: { user in
                DispatchQueue.main.async(execute: {
                    ctrl.profileImage.image = #imageLiteral(resourceName: "images") //TODO
                    ctrl.login.text = user.name
                    UIViewController.removeSpinner(spinner: sv)
                })
                
            },
            
            error: {error in
                if( self.checkToken(error: error, spinner:sv) ) {
                    
                    DispatchQueue.main.async(execute: {
                        UIViewController.removeSpinner(spinner: sv)
                        self.alert(error["message"] as! String)
                    })
                    
                }
            }
        )
        
        
        repo.getFriends (
            result: { data in
                self.userArray = data
                
                DispatchQueue.main.async(execute: {
                    self.table.reloadData()
                    UIViewController.removeSpinner(spinner: sv)
                })
            
            },
            error: {error in
                
                if( self.checkToken(error: error, spinner:sv) ) {
                    
                    DispatchQueue.main.async(execute: {
                        UIViewController.removeSpinner(spinner: sv)
                        self.alert(error["message"] as! String)
                    })
                    
                }
                
            }
        )
    }
    
    //TableView
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userArray.count
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Friends"
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath) as? FriendCell  else {
            fatalError()
        }
        
     
        cell.cellName?.text = userArray[indexPath.row].name
        cell.cellImage?.image = #imageLiteral(resourceName: "person-profile") //TODO
        
        return cell
    }
    
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedFriend = userArray[indexPath.row]
        let vc = storyboard?.instantiateViewController(withIdentifier: "FriendProfile") as! FriendProfileViewController
        vc.friendId = selectedFriend.id
        vc.status = "Accepted"
        self.present(vc, animated: true, completion: nil)
    }
    
    //Fin Table
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func addFriendButtonTapped(_ sender: UIBarButtonItem) {
        
        guard !search.text!.isEmpty else {
            alert("All fields are required")
            return
        }
        
    }
    
    @IBAction func mapButtonTapped(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "profileToMap", sender: self)
    }
 
}
