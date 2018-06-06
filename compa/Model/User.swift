//
//  User.swift
//  compa
//
//  Created by m2sar on 14/05/2018.
//  Copyright © 2018 m2sar. All rights reserved.
//

import UIKit
import CoreLocation

public class User {
    

    let id, login, name : String, email: String
    let imgUrl : String?
    let ghostMode : Bool
    let lastLocation : Location?
    var image : UIImage?
    
    init(login: String, location:Location?, name:String, id:String, ghostMode:Bool, email: String, imgUrl: String?){
        self.login = login
        self.name = name
        self.id = id
        self.lastLocation = location
        self.ghostMode = ghostMode
        self.email = email
        self.imgUrl = imgUrl
    }
    
    convenience init?(dictionary: [String:Any]) {
        let name = dictionary["name"]! as! String
        let login = dictionary["login"]! as! String
        let id = dictionary["id"]! as! String
        let ghostMode = dictionary["ghostMode"]! as! Bool
        let email = dictionary["email"]! as! String
        
        var location : Location?
        
        if let dic = dictionary["lastLocation"] as? [String:Any] {
            location = Location(dictionary: dic)
        }
      
        let imgUrl = dictionary["profilePicUrl"] as? String
        
        self.init(login:login, location: location, name:name, id:id, ghostMode:ghostMode, email:email, imgUrl:imgUrl)
    }

    
    
}
