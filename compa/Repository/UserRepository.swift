//
//  UserRepository.swift
//  compa
//
//  Created by m2sar on 14/05/2018.
//  Copyright © 2018 m2sar. All rights reserved.
//

import Foundation

class UserRepository {

    let http: HTTPService = HTTPService()
    
    func getAll(result: @escaping (_ data: [User] )->Void, error: @escaping (_ data: [String:Any] )->Void )  {
        result([User(dictionary: [:])!])
    }
    
    func getFriends(result: @escaping (_ data: [User]) -> Void, error: @escaping (_ data: [String:Any] )->Void ) {
        
        http.get(
            isRelative: true,
            isAuthenticated: true,
            url: "/friend/pending",
            success: { data in
                result(Array(data.values).map { User(dictionary: $0 as! [String : Any])! } )
            },
        
            error: { error in
        
            }
        )
        
    }
    
    func getBlocked(result: @escaping (_ data: [User]) -> Void, error: @escaping (_ data: [String:Any] )->Void ) {
        
        http.get(
            isRelative: true,
            isAuthenticated: true,
            url: "/friend/blocked",
            success: { data in
              result(Array(data.values).map { User(dictionary: $0 as! [String : Any])! } )
            },
            
            error: { error in
                
            }
        )
        
    }
    //request I have received
    func getPending(result: @escaping (_ data: [User]) -> Void, error: @escaping (_ data: [String:Any] )->Void ) {
        
        http.get(
            isRelative: true,
            isAuthenticated: true,
            url: "/friend/pending",
            success: { data in
               result(Array(data.values).map { User(dictionary: $0 as! [String : Any])! } )
            },
            
            error: { error in
                
            }
        )
        
    }
    
    //request I have made
    func getAwaiting(result: @escaping (_ data: [User]) -> Void, error: @escaping (_ data: [String:Any] )->Void ) {
        
        http.get(
            isRelative: true,
            isAuthenticated: true,
            url: "/friend/awaiting",
            success: { data in
                result(Array(data.values).map { User(dictionary: $0 as! [String : Any])! } )
            },
            
            error: { error in
                
            }
        )
        
    }
    
    
    
    func get(identifier:String, result: @escaping (_ data: User )->Void, error: @escaping (_ data: [String:Any] )->Void ) {
        
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

    func update( object: User, result: @escaping (_ data: Bool )->Void, error: @escaping (_ data: [String:Any] )->Void ) {
        result(true)
    }

    func delete( object: User, result: @escaping (_ data: Bool )->Void, error: @escaping (_ data: [String:Any] )->Void  ) {
        result(true)
    }
    
    func getAuthUser(result: @escaping (_ data: User )->Void, error: @escaping (_ data: [String:Any] )->Void ){
        get(identifier: "", result:result, error:error)
    }
    
}

