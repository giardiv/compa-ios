//
//  BlockedUsersTableView.swift
//  compa
//
//  Created by m2sar on 24/05/2018.
//  Copyright © 2018 m2sar. All rights reserved.
//

import UIKit

class BlockedUsersTableView: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var table: UITableView!
  
    let repo = UserRepository()
    let imageService = ImageService()
    let friendshipRepo = FriendshipRepository()
    
    var blockedUsers : [User] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.reloadTable()
    }
    
    func reloadTable () {
        let sv = UIViewController.displaySpinner(onView: self.view)
        
        repo.getBlocked(
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
                    self.blockedUsers = data
                    self.table.reloadData()
                    UIViewController.removeSpinner(spinner: sv)
                }

                
            },
            error: { error in
                
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
        return blockedUsers.count
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Blocked Users"
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let ctrl = self
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "blockedCell", for: indexPath) as? BlockedCell  else {
            fatalError("not sure what's happening.")
        }
        
        let user = blockedUsers[indexPath.row]
        cell.cellName?.text = user.name
        cell.cellImage?.image = user.image != nil ? user.image : #imageLiteral(resourceName: "person-profile")
        cell.blockUserAction = {action in
            ctrl.friendshipRepo.deblockUser(friendId: user.id, result: { data in
                DispatchQueue.main.async {
                    ctrl.alert(user.name + " is deblocked !", title: "Successful")
                    ctrl.reloadTable()
                }
            }, error: { error in
                
                ctrl.alert(error["message"] as! String)
            })
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedFriend = blockedUsers[indexPath.row]
        let vc = FriendProfileViewController()
        vc.friendId = selectedFriend.id
        DispatchQueue.main.async(execute: {
            self.performSegue(withIdentifier: "profileToFriend", sender: self)
        })
    }
    
}
