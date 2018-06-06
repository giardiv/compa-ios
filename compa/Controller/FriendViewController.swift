//
//  ProfileViewController.swift
//  compa
//
//  Created by m2sar on 18/05/2018.
//  Copyright © 2018 m2sar. All rights reserved.
//

import UIKit

class FriendViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var search: SearchTextField!
    
    let imageService = ImageService()
    let repo = UserRepository()
    let friendshipRep = FriendshipRepository()
    var selectedUser : User?
    
    var userArray : [User] = []
    
    
    @IBOutlet weak var addUserButton: UIBarButtonItem!
    
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
                            
                            let group = DispatchGroup()
                            
                            for user in data {
                                
                                if let img = user.imgUrl {
                                    
                                    group.enter()
                                    self.imageService.downloadImage(
                                        url: img,
                                        successHandler: {data2 in
                                            user.image = data2
                                            group.leave()
                                    },
                                        errorHandler: {error in }
                                    )
                                }
                            }
                            
                            group.notify(queue: DispatchQueue.main) {
                                let results = data.map { SearchTextFieldItem(title: $0.name, subtitle: $0.login, image: $0.image, user:$0) }
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
        
        search.itemSelectionHandler = { data, index in
             self.selectedUser = data[index].user!
             self.addUserButton?.isEnabled = true
        }
        
        search.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
    }
    
    func textFieldDidChange(_ textField: UITextField) {
        selectedUser = nil
        addUserButton?.isEnabled = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
      reloadTable()
    }
    
    
    func reloadTable(){
        
        let sv = UIViewController.displaySpinner(onView: self.view)
        
        
        repo.getFriends (
            result: { data in
                
                let group = DispatchGroup()
                
                for user in data {
                    
                    if let img = user.imgUrl {
                        
                        group.enter()
                        self.imageService.downloadImage(
                            url: img,
                            successHandler: {data2 in
                                user.image = data2
                                group.leave()
                        },
                            errorHandler: {error in }
                        )
                        
                    }
                }
                
                group.notify(queue: DispatchQueue.main) {
                    self.userArray = data
                    self.table.reloadData()
                    UIViewController.removeSpinner(spinner: sv)
                    
                }

                
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
        
        let user = userArray[indexPath.row]
        
        cell.cellName?.text = user.name
        cell.cellImage?.image = user.image != nil ? user.image : #imageLiteral(resourceName: "person-profile")
        
        return cell
    }
    
    
    @IBAction func searchButtonTapped(_ sender: Any) {
       
        if let user = selectedUser {
            friendshipRep.requestFriendship (
                friendId: user.id,
                result: { data in
                    DispatchQueue.main.async {
                        self.reloadTable()
                    }
                },
                error: { error in
                    DispatchQueue.main.async {
                        self.alert(error["message"] as! String)
                    }
                }
            )
        }
        
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedFriend = userArray[indexPath.row]
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FriendProfile") as! FriendProfileViewController
        vc.friendId = selectedFriend.id
        vc.status = "Accepted"
        self.present(vc, animated: true, completion: nil)
    }
    
    //Fin Table
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
   
    @IBAction func mapButtonTapped(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "profileToMap", sender: self)
    }
 
}
