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
    
    init?(dictionary: Dictionary<String, AnyObject>) {
        username = dictionary["username"]! as! String
        friendships = [Friendship]()
        locations = Dictionary<Date, CLLocation>()
    }
    
    init(){
        username = "soMysterious"
        friendships = [Friendship]()
        locations = User.getMockLocationsFor(CLLocation(latitude:51.509865, longitude:-0.118092))
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
