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
    
    static let dateFormatter = { () -> DateFormatter in
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        return dateFormatter
    }()
    
    init(dictionary: Dictionary<String, Any>){
        latitude = dictionary["latitude"] as! Double
        longitude = dictionary["longitude"] as! Double
        let date: Date = Location.dateFormatter.date(from: dictionary["datetime"] as! String)!
        self.date = date

    }
    
    func toDictionary() -> [String:Any] {
        return ["latitude" : latitude, "longitude": longitude, "date": Location.dateFormatter.string(from: date)]
    }
    
}
