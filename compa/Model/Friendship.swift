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
    
    /*
        To discuss with back : recursive reference problem :
        the users inside a friendship should not contain their own
        friendships (if they do then their friends shouldn't...)
        empty friendship array (++) or no array at all (--) ?
    */
    
    static let test = { () ->  Dictionary<String, AnyObject> in
        var dic = Dictionary<String, AnyObject>()
        dic["status"] = "friends" as? AnyObject
        dic["date"] = "10-11-2017 21:01:54" as? AnyObject
        
        var left = Dictionary<String, AnyObject>()
        left["username"] = "friend1" as? AnyObject
        left["friendships"] = [] as? AnyObject
        dic["left"] = left as AnyObject
        
        var right = Dictionary<String, AnyObject>()
        right["username"] = "friend2" as? AnyObject
        right["friendships"] = [] as? AnyObject
        dic["right"] = right as AnyObject
        
        return dic
    }()
    
    static let dateFormatter = { () -> DateFormatter in
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss" //TODO Determine format of date string
        return dateFormatter
    }()
    
    init(left: User, right: User, status: String, date: Date){
        self.left = left
        self.right = right
        self.status = status
        self.date = date
    }
    
    convenience init(){
        self.init(left: User(), right: User(), status: "it's complicated", date: Date())
    }
    
    convenience init(dictionary: Dictionary<String, AnyObject>){
        let userLeft = User(dictionary: dictionary["left"] as! Dictionary<String, AnyObject>)!
        let userRight = User(dictionary: dictionary["right"] as! Dictionary<String, AnyObject>)!
        let status = dictionary["status"] as! String
        let date = Friendship.dateFormatter.date(from: dictionary["date"] as! String)!
        //TODO Handle errors (if dic in wrong format)
        self.init(left: userLeft, right: userRight, status:status, date: date)
    }
    
}
