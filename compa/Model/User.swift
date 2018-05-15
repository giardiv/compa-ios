//
//  User.swift
//  compa
//
//  Created by m2sar on 14/05/2018.
//  Copyright © 2018 m2sar. All rights reserved.
//

import Foundation


class User {
    
    
    let username : String
    
    init?(dictionary: Dictionary<String, AnyObject>) {
        username = dictionary["username"]! as! String
    }
    
    init(){
        username = ""
    }
}
