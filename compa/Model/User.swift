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
    let friends : [User]
    let lastLocation : Location
    
    //let imageURL, firstName, lastName:String
    //let dob:Date
    
    init(username: String, location:Location, friends: [User]){
        self.username = username
        self.friends = friends
        self.lastLocation = location
    }
    
    convenience init?(dictionary: [String:Any]) {
        let name: String = dictionary["username"]! as! String
        let location = Location(dictionary: dictionary["location"]! as! [String:Any])
        let friendsDic = dictionary["friends"]! as! [String:Any]
        let friends = friendsDic.map { User(dictionary: $0.1 as! [String:Any])! } //problem
        self.init(username: name, location: location, friends: friends)
    }
    
    
    //User.getMockLocationsFor(CLLocation(latitude:51.509865, longitude:-0.118092)) // to change
    
    
    static func getMockLocationsFor(_ location: CLLocation) -> [Date:CLLocation] {
        
        func getBase(number: Double) -> Double {
            return round(number * 1000)/1000
        }
        func randomCoordinate() -> Double {
            return Double(arc4random_uniform(140)) * 0.0001
        }
        
        var dic = [Date:CLLocation]();
        
        let baseLatitude = getBase(number: location.coordinate.latitude - 0.007)
        let baseLongitude = getBase(number: location.coordinate.longitude - 0.008)
        
        for i in stride(from: -10000, to: 10000, by: 1000) {
            let date = Date(timeIntervalSinceNow: Double(i));
            let randomLat: Double = baseLatitude + randomCoordinate()
            let randomLong: Double = baseLongitude + randomCoordinate()
            dic[date] = CLLocation(latitude: randomLat, longitude: randomLong)
        }
        
        return dic
    }
    
}
