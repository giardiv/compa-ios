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
}
