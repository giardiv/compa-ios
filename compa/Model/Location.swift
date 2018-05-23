//
//  Location.swift
//  compa
//
//  Created by m2sar on 22/05/2018.
//  Copyright © 2018 m2sar. All rights reserved.
//

import Foundation


class Location {
    
    let latitude, longitude: Double
    let date : Date
    
    init(dictionary: Dictionary<String, Any>){
        latitude = dictionary["latitude"] as! Double
        longitude = dictionary["longitude"] as! Double
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "dd-MM-yyyy HH:mm:ss"
        let date: Date = dateFormatterGet.date(from: dictionary["date"] as! String)!
        self.date = date

    }
    
}
