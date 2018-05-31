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
        
        let sv = UIViewController.displaySpinner(onView: self.view)
        
        repo.getAwaiting (
            result: { data in
                //check error
                self.userArray = data
                
                DispatchQueue.main.async(execute: {
                    self.table.reloadData()
                    UIViewController.removeSpinner(spinner: sv)
                })
                
            },
            error: {error in
                
            }
        )
    }

    
    //TableView
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userArray.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "requestCell", for: indexPath) as? RequestCell  else {
            fatalError("not sure what's happening.")
        }
        
        cell.cellName?.text = userArray[indexPath.row].name
        cell.cellImage?.image = #imageLiteral(resourceName: "person-profile")
        
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
