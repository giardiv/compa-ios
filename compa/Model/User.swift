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
    

    let id, login, name : String
    let ghostMode : Bool
    let lastLocation : Location
        
    init(login: String, location:Location, name:String, id:String, ghostMode:Bool){
        self.login = login
        self.name = name
        self.id = id
        self.lastLocation = location
        self.ghostMode = ghostMode
    }
    
    convenience init?(dictionary: [String:Any]) {
        let name = dictionary["name"]! as! String
        let login = dictionary["login"]! as! String
        let id = dictionary["id"]! as! String
        let ghostMode = dictionary["ghostMode"]! as! Bool
        let location = Location(dictionary: dictionary["lastLocation"]! as! [String:Any])
        self.init(login:login, location: location, name:name, id:id, ghostMode:ghostMode)
    }

    
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
