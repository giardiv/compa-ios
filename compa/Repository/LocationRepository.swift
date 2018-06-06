//
//  LocationRepository.swift
//  compa
//
//  Created by Sarah on 30/05/2018.
//  Copyright © 2018 m2sar. All rights reserved.
//

import Foundation


class LocationRepository {
    var http: HTTPService = HTTPService()
    
    func getAll(result: @escaping (_ data: [Location] )->Void){}
    
    func get(identifier:String, result: @escaping (_ data: Location )->Void){}
    
    func create(object: Location, result: @escaping (_ data: [String:Any] )->Void, error: @escaping (_ data: [String:Any] )->Void){
        
        http.post(
            isRelative: true,
            isAuthenticated: true,
            url: "/location",
            data: object.toDictionary(),
            success: result,
            error: error
        )
    }
    
    
    func getFriendLocations(identifier: String, result: @escaping (_ data: [Location] )->Void, error: @escaping (_ data: [String:Any] )->Void){
        
        http.get(
            isRelative: true,
            isAuthenticated: true,
            url: "/location/friend/" + identifier,
            success: { data in
                result(Array(data.values).map { Location(dictionary: $0 as! [String : Any]) } )
            },
            error: error
        )
    }
    
}
