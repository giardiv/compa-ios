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
    let imageService = ImageService()
    var requestsPending : [User] = []
    var requestsSended : [User] = []
    
    override func viewWillAppear(_ animated: Bool) {
        reloadTable()
    }
    
    private func reloadTable() {
        
        let sv = UIViewController.displaySpinner(onView: self.view)
        let group = DispatchGroup()
        
        group.enter()
        repo.getAwaiting (
            result: { data in
                
                let awaitingGroup = DispatchGroup()
                
                for user in data {
                    
                    if let img = user.imgUrl {
                        
                        awaitingGroup.enter()
                        self.imageService.downloadImage(
                            url: img,
                            successHandler: {data2 in
                                user.image = data2
                                awaitingGroup.leave()
                        },
                            errorHandler: {error in }
                        )
                        
                    }
                }
                
                awaitingGroup.notify(queue: DispatchQueue.main) {
                    self.requestsPending = data
                    group.leave()
                }

                
            },
            error: {error in
                
                group.leave()
                
                if( self.checkToken(error: error, spinner:sv) ) {
                    DispatchQueue.main.async {
                        UIViewController.removeSpinner(spinner: sv)
                        self.alert(error["message"] as! String)
                    }
                }
                
            }
        )
        group.enter()
        repo.getPending (
            result: { data in
                
                let pendingGroup = DispatchGroup()
                
                for user in data {
                    
                    if let img = user.imgUrl {
                        
                        pendingGroup.enter()
                        self.imageService.downloadImage(
                            url: img,
                            successHandler: {data2 in
                                user.image = data2
                                pendingGroup.leave()
                        },
                            errorHandler: {error in }
                        )
                        
                    }
                }
                
                pendingGroup.notify(queue: DispatchQueue.main) {
                    self.requestsSended = data
                    group.leave()
                }

            },
            error: {error in
                group.leave()
                if( self.checkToken(error: error, spinner:sv) ) {
                    DispatchQueue.main.async {
                        UIViewController.removeSpinner(spinner: sv)
                        self.alert(error["message"] as! String)
                    }
                    
                }
            }
        )
        
        
        group.notify(queue: DispatchQueue.main) {
            self.table.reloadData()
            UIViewController.removeSpinner(spinner: sv)
        }

    }

    
    //TableView
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? requestsPending.count : requestsSended.count
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ?  "Friend Request" : "Request Sended"
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
        guard (self.requestsPending.count != 0) else {
            return cell
        }
        
        let user = requestsPending[indexPath.row]
        cell.cellName?.text = user.name
        cell.cellImage?.image = user.image != nil ? user.image : #imageLiteral(resourceName: "person-profile")
        
        cell.requestAction = {action in
            if(action == "confirm"){
                ctrl.friendshipRepo.confirmFriendshipRequest(
                    friendId: user.id,
                    result: { data in
                    
                        DispatchQueue.main.async {
                            ctrl.alert("You are now friend with " + ctrl.requestsPending[indexPath.row].name + " !")
                            ctrl.reloadTable()
                        }
                    },
                    error: { error in
                        ctrl.alert(error["message"] as! String)
                    }
                )
                
            } else if (action == "reject"){
                
                ctrl.friendshipRepo.rejectFriendshipRequest(
                    friendId: user.id,
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
        guard (self.requestsSended.count != 0) else {
            return cell
        }
        
        let user = requestsSended[indexPath.row]
        cell.cellName?.text = user.name
        cell.cellImage?.image = user.image != nil ? user.image : #imageLiteral(resourceName: "person-profile")
        cell.action = {_ in
            
            ctrl.friendshipRepo.deleteFriendship (
                friendId: user.id,
                result: { data in
                    DispatchQueue.main.async {
                        ctrl.alert("The request has been deleted")
                        ctrl.reloadTable()
                    }
                },
                error: { error in
                    ctrl.alert(error["message"] as! String)
                }
            )
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.section == 0){
            let selectFriend = requestsPending[indexPath.row]
            let vc = storyboard?.instantiateViewController(withIdentifier: "FriendProfile") as! FriendProfileViewController
            vc.friendId = selectFriend.id
            vc.status = "Awaiting"
            self.present(vc, animated: true, completion: nil)
        }
       
    }
    
}
