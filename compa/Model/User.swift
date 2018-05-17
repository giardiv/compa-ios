//
//  User.swift
//  compa
//
//  Created by m2sar on 14/05/2018.
//  Copyright © 2018 m2sar. All rights reserved.
//

import Foundation
import CoreLocation

class User {
    
    let username : String
    let friendships : [Friendship]
    let locations : Dictionary<Date, CLLocation>
    
    static let test = { () ->  Dictionary<String, AnyObject> in
        var dic = Dictionary<String, AnyObject>()
        dic["username"] = "main" as AnyObject
        dic["friendships"] = Friendship.test as AnyObject
        return dic
    }()
    
    init(username: String, locations: Dictionary<Date, CLLocation>, friendships: [Friendship]){
        self.username = username
        self.friendships = friendships
        self.locations = locations
    }
    
    convenience init?(dictionary: Dictionary<String, AnyObject>) {
        let name = dictionary["username"]! as! String
        
        let locations = User.getMockLocationsFor(CLLocation(latitude:51.509865, longitude:-0.118092)) //to change
       
        let friendshipsDic = dictionary["friendship"]! as! Dictionary<String, AnyObject>
        let friendships = friendshipsDic.map { Friendship(dictionary: $0.1 as! Dictionary<String, AnyObject>) }
        
        self.init(username: name, locations: locations, friendships: friendships)
    }
    
    convenience init(){
        self.init(username:"soMysterious", locations: User.getMockLocationsFor(CLLocation(latitude:51.509865, longitude:-0.118092)),
                  friendships: [Friendship]())
    }
 
    static func getMockLocationsFor(_ location: CLLocation) -> Dictionary<Date, CLLocation> {
        
        func getBase(number: Double) -> Double {
            return round(number * 1000)/1000
        }
        func randomCoordinate() -> Double {
            return Double(arc4random_uniform(140)) * 0.0001
        }
        
        var dic = Dictionary<Date, CLLocation>();
        
        let baseLatitude = getBase(number: location.coordinate.latitude - 0.007)
        let baseLongitude = getBase(number: location.coordinate.longitude - 0.008)
        
        for i in stride(from: -10000, to: 10000, by: 100) {
            let date = Date(timeIntervalSinceNow: Double(i));
            let randomLat = baseLatitude + randomCoordinate()
            let randomLong = baseLongitude + randomCoordinate()
            dic[date] = CLLocation(latitude: randomLat, longitude: randomLong)
        }
        
        return dic
    }
    
}
