//
//  FriendRequestTableView.swift
//  compa
//
//  Created by m2sar on 24/05/2018.
//  Copyright © 2018 m2sar. All rights reserved.
//

import UIKit

class FriendRequestTableView: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    let list = ["Toto", "Tata", "Titi"]
    
    //TableView
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "friendRequestCell", for: indexPath) as? EditProfileFriendRequestCell  else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        
        cell.friendRequestUsername?.text = list[indexPath.row]
        cell.friendRequestImage?.image = #imageLiteral(resourceName: "person-profile")
        
        return cell
    }
    //Fin Table
}
