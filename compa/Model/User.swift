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
    
<<<<<<< HEAD
    let username : String
    let friends : [User]
=======
    let id, login, name : String
>>>>>>> 9d6a185ce5f5cad5fdc1ee2bc72f1b218c58881a
    let lastLocation : Location
    
    //let imageURL, firstName, lastName:String
    //let dob:Date
    
<<<<<<< HEAD
    init(username: String, location:Location, friends: [User]){
        self.username = username
        self.friends = friends
        self.lastLocation = location
    }
    
    convenience init?(dictionary: Dictionary<String, AnyObject>) {
        let name = dictionary["username"]! as! String
        
        let location = Location(dictionary: dictionary["location"]! as! Dictionary<String, AnyObject>)
        
        //User.getMockLocationsFor(CLLocation(latitude:51.509865, longitude:-0.118092)) // to change
       
        let friendsDic = dictionary["friends"]! as! Dictionary<String, AnyObject>
        //let friends = friendsDic.map { User(dictionary: $0 as! [String:AnyObject]!) }
        
        //self.init(username: name, location: location, friends: friends)
=======
    init(login: String, location:Location, name:String, id:String){
        self.login = login
        self.name = name
        self.id = id
        self.lastLocation = location
    }
    
    convenience init?(dictionary: [String:Any]) {
        let name: String = dictionary["name"]! as! String
        let login = dictionary["login"]! as! String
        let id = dictionary["id"]! as! String
        let location = Location(dictionary: dictionary["lastLocation"]! as! [String:Any])
        self.init(login:login, location: location, name:name, id:id)
>>>>>>> 9d6a185ce5f5cad5fdc1ee2bc72f1b218c58881a
    }

    
<<<<<<< HEAD
    convenience init(){
        self.init(username:"soMysterious", location: Location(), friends: [User]())
    }
    
 
    static func getMockLocationsFor(_ location: CLLocation) -> Dictionary<Date, CLLocation> {
=======
    
    //User.getMockLocationsFor(CLLocation(latitude:51.509865, longitude:-0.118092)) // to change
    
    
    static func getMockLocationsFor(_ location: CLLocation) -> [Date:CLLocation] {
>>>>>>> 9d6a185ce5f5cad5fdc1ee2bc72f1b218c58881a
        
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
