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
    
    func getAll(result: @escaping (_ data: [User] )->Void)  {
        result([User(dictionary: [:])!])
    }
    
    func get(identifier:String, result: @escaping (_ data: User )->Void) {
        
        http.get(
            isRelative: true,
            isAuthenticated: true,
            url: "/user" + identifier,
            success: { data in
                result(User(dictionary:data)!)
            },
            
            error: { error in
                
            }
        )
        
    }

    func create( object: User, result: @escaping (_ data: Bool )->Void ) {
        result(true)
    }

    func update( object: User, result: @escaping (_ data: Bool )->Void) {
        result(true)
    }

    func delete( object: User, result: @escaping (_ data: Bool )->Void ) {
        result(true)
    }
    
    func getAuthUser(result: @escaping (_ data: User )->Void){
          get(identifier: "", result:result)
    }
    
}

