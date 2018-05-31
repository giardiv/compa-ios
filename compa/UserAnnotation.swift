//
//  UserWishListAnnotation.swift
//  CustomPinsMap
//
//  Created by m2sar on 31/05/2018.
//  Copyright © 2018 Ignacio Nieto Carvajal. All rights reserved.
//


import UIKit
import MapKit

class UserAnnotation: NSObject, MKAnnotation {
    var user: User
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: user.lastLocation.latitude, longitude: user.lastLocation.longitude)
    }
    
    init(user: User) {
        self.user = user
        super.init()
    }
    
    var title: String? {
        return user.name
    }
    
    var subtitle: String? {
        return user.login
    }
    
}
