//
//  Location.swift
//  compa
//
//  Created by m2sar on 22/05/2018.
//  Copyright © 2018 m2sar. All rights reserved.
//

import Foundation
import CoreLocation

class Location {
    
    let latitude, longitude: Double
    let date : Date
    
    static let dateFormatter = { () -> DateFormatter in
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        return dateFormatter
    }()
    
    convenience init(dictionary: Dictionary<String, Any>){
        let latitude = dictionary["latitude"] as! Double
        let longitude = dictionary["longitude"] as! Double
        let date: Date = Location.dateFormatter.date(from: dictionary["datetime"] as! String)!
        self.init(latitude:latitude, longitude:longitude, date:date)
    }
    
    init(latitude: Double, longitude:Double, date:Date){
        self.latitude = latitude
        self.longitude = longitude
        self.date = date
    }
    
    func toDictionary() -> [String:Any] {
        return ["latitude" : latitude, "longitude": longitude, "date": Location.dateFormatter.string(from: date)]
    }
    
    func toCoordinate() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude:latitude, longitude:longitude)
    }
    
    
}
