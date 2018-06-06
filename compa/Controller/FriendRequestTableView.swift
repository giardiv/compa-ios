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
    var requestSendedArray : [User] = []
    
    let test = ["toto", "titi", "tata"]
    
    
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
                    DispatchQueue.main.async(execute: {
                        UIViewController.removeSpinner(spinner: sv)
                        self.alert(error["message"] as! String)
                    })
                    
                }
            }
        )
        
        repo.getPending (
            result: { data in
                self.requestSendedArray = data
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
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0){
            return userArray.count
        } else {
            return requestSendedArray.count
        }
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section == 0){
            return "Friend Request"
        } else {
            return "Request Sended"
        }
        
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.section == 0){
            return loadFriendRequestCell(indexPath: indexPath, tableView: tableView)
        } else {
            return loadRequestSendedCell(indexPath: indexPath, tableView: tableView)
        }
    }
    
    func loadFriendRequestCell(indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        let ctrl = self
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "requestCell", for: indexPath) as? RequestCell  else {
            fatalError("not sure what's happening.")
        }
        guard (self.userArray.count != 0) else {
            return cell
        }
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
    
    func loadRequestSendedCell(indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        let ctrl = self
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "requestSendedCell", for: indexPath) as? RequestSendedCell  else {
            fatalError("not sure what's happening.")
        }
        guard (self.requestSendedArray.count != 0) else {
            return cell
        }
        
        cell.cellName?.text = requestSendedArray[indexPath.row].name
        cell.cellImage?.image = #imageLiteral(resourceName: "person-profile")
        cell.action = {_ in
            ctrl.friendshipRepo.deleteFriendship(
                friendId: ctrl.requestSendedArray[indexPath.row].id,
                result: { data in
                    ctrl.alert("The request has been deleted")
                    ctrl.reloadTable()
            }, error: { error in
                ctrl.alert(error["message"] as! String)
            })
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.section == 0){
            let selectFriend = userArray[indexPath.row]
            let vc = storyboard?.instantiateViewController(withIdentifier: "FriendProfile") as! FriendProfileViewController
            vc.friendId = selectFriend.id
            vc.status = "Awaiting"
            self.present(vc, animated: true, completion: nil)
        }
       
    }
    
}
