//
//  UserRepository.swift
//  compa
//
//  Created by m2sar on 14/05/2018.
//  Copyright © 2018 m2sar. All rights reserved.
//

import Foundation

class UserRepository : AbstractRepository {

    typealias model = User
    
    
    let http: HTTPService
    
    init(http: HTTPService = HTTPService()) {
        self.http = http
    }
    
    
    func getAll() -> [User] {
        return [User()]
    }
    
    func get( identifier:Int ) -> User?{
        let serializedObj = ""; //async func....
        return User(dictionary: serializedObj!)
    }

    func create( object: User ) -> Bool{
        return true
    }

    func update( object: User) -> Bool{
        return true
    }

    func delete( object: User ) -> Bool{
        return true
    }
    
    
}

