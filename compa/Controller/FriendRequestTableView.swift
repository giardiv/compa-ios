//
//  FriendRequestTableView.swift
//  compa
//
//  Created by m2sar on 24/05/2018.
//  Copyright © 2018 m2sar. All rights reserved.
//

import UIKit

class FriendRequestTableView: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var table: UITableView!
    
    let repo = UserRepository()
    let friendshipRepo = FriendshipRepository()
    
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
        reloadTable()
    }
    
    func reloadTable () {
        let sv = UIViewController.displaySpinner(onView: self.view)
        
        repo.getAwaiting (
            result: { data in
                self.userArray = data
                DispatchQueue.main.async(execute: {
                    self.table.reloadData()
                    UIViewController.removeSpinner(spinner: sv)
                })
                
            },
            error: {error in
                if( self.checkToken(error: error, spinner:sv) ) {
                    //check error
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
        return "Friend Request"
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "requestCell", for: indexPath) as? RequestCell  else {
            fatalError("not sure what's happening.")
        }
        let ctrl = self
        cell.cellName?.text = userArray[indexPath.row].name
        cell.cellImage?.image = #imageLiteral(resourceName: "person-profile")
        cell.requestAction = {action in
            if(action == "confirm"){
                ctrl.friendshipRepo.confirmFriendshipRequest(friendId: ctrl.userArray[indexPath.row].id, result: { data in
                    DispatchQueue.main.async {
                        ctrl.alert("You are now friend with " + ctrl.userArray[indexPath.row].name + " !")
                        ctrl.reloadTable()
                    }
                }, error: { error in
                 
                    ctrl.alert(error["message"] as! String)
                })
            } else if (action == "reject"){
                ctrl.friendshipRepo.rejectFriendshipRequest(
                    friendId: ctrl.userArray[indexPath.row].id,
                    result: { data in
                        DispatchQueue.main.async {
                            ctrl.alert("The friend request has been rejected :)")
                            ctrl.reloadTable()
                        }
                    },
                    error: { error in
                        ctrl.alert(error["message"] as! String)
                    }
                )
            }
        
            
            
        }
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedFriend = userArray[indexPath.row]
        let vc = storyboard?.instantiateViewController(withIdentifier: "FriendProfile") as! FriendProfileViewController
        vc.friendId = selectedFriend.id
        vc.status = "Awaiting"
        self.present(vc, animated: true, completion: nil)
    }
    
}
