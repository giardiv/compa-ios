//
//  Location.swift
//  compa
//
//  Created by m2sar on 22/05/2018.
//  Copyright © 2018 m2sar. All rights reserved.
//

import Foundation


class Location {
    
<<<<<<< HEAD
    let latitude, longitude:Double
    let date : Date
    
    init(dictionary: Dictionary<String, AnyObject>){
    
    }
    
    init(){
        
    }
=======
    let latitude, longitude: Double
    let date : Date
    
    init(dictionary: Dictionary<String, Any>){
        latitude = dictionary["latitude"] as! Double
        longitude = dictionary["longitude"] as! Double
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "dd-MM-yyyy HH:mm:ss"
        let date: Date = dateFormatterGet.date(from: dictionary["datetime"] as! String)!
        self.date = date

    }
    
>>>>>>> 9d6a185ce5f5cad5fdc1ee2bc72f1b218c58881a
}
