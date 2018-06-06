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
    let user: User
    var coordinate: CLLocationCoordinate2D {
        return user.lastLocation!.toCoordinate()
    }
    
    init(user: User) {
        self.user = user
        super.init()
    }
    
}
