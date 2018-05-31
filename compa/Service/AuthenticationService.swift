//
//  AuthenticationService.swift
//  compa
//
//  Created by m2sar on 16/05/2018.
//  Copyright © 2018 m2sar. All rights reserved.
//

import Foundation


class AuthenticationService {
    
    
    let http: HTTPService
    
    init(http: HTTPService = HTTPService()) {
        self.http = http
    }
    
    func checkAuth(login : String, pwd : String, result: @escaping (_ data: String )->Void, error: @escaping (_ data: [String:Any] )->Void){
    
        http.post(
            isRelative: true,
            isAuthenticated: false,
            url: "/login",
            data: ["login": login, "password": pwd],
            success: { data in
                if let token  = data["token"] as? String {
                    result(token)
                }
                else{
                   error(["message" : "Something went wrong"])
                }
            },
            error: error
        )       
        
    }
    
    func register(credentials: [String : String], result: @escaping (_ data: String )->Void, error: @escaping (_ data: [String:Any] )->Void){
        
        http.post(
            isRelative: true,
            isAuthenticated: false,
            url: "/register",
            data: credentials,
            success: { data in
                if let token  = data["token"] as? String {
                  result(token)
                }
                else{
                    error(["message" : "Something went wrong"])
                }
            },
            error: error
        )

    }
    
    func logout(result: @escaping (_ data: String) -> Void, error: @escaping(_ data : [String:Any]) -> Void) {
       
        http.put(
            isRelative: true,
            isAuthenticated: true,
            url: "/logout",
            data: [:],
            success: {data in
                result("")},
            error: error
        )
    }
    
}
