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
    
    let root:String
    
    
    init(http: HTTPService = HTTPService()) {
        self.http = http
        
        let path = Bundle.main.path(forResource: "Info", ofType: "plist")!
        let dict = NSDictionary(contentsOfFile: path)!
        root = dict["root"] as! String
        print(root)
        
    }
    
    func getAll(result: @escaping (_ data: [User] )->Void)  {
        result([User(dictionary: [:])!])
    }
    
    func get(identifier:String, result: @escaping (_ data: User )->Void) {
        
        var url = root + "/user"
        if identifier != "" {
            url += identifier
        }
        
        http.get(
            isAuthenticated: true,
            url: url,
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

