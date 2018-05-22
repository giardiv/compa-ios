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
    
    func get( identifier:Int, result: @escaping (_ data: User )->Void) {
        result(User(dictionary: [:])!)
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
    
    func getAuthUser(result: @escaping (_ data: Bool )->Void){
        
        http.get(
            url: root + "/user/profile",
            success: { data in
                result(User(dictionary:data))
            },
            
            error: { error in
            
            }
    
        )
    }
    
}

