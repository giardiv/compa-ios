//
//  Friendship.swift
//  compa
//
//  Created by m2sar on 16/05/2018.
//  Copyright © 2018 m2sar. All rights reserved.
//

import Foundation

class Friendship {
    
    let left, right: User
    let status : String //enum
    let date : Date
    
    init(){
        left = User()
        right = User()
        status = "it's complicated"
        date = Date()
    }
    
}
