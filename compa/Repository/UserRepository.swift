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
        result([User()])
    }
    
    func get( identifier:Int, result: @escaping (_ data: User )->Void) {
        result(User())
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
    
}

