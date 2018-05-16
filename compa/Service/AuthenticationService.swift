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
    
    func checkAuth(login : String, pwd : String, result: @escaping (_ data: String )->Void, error: @escaping (_ data: String )->Void){
        //http.get(url: <#T##String#>, success: <#T##(Dictionary<String, AnyObject>) -> Void#>, error: <#T##(Error) -> Void#>)

        if(arc4random_uniform(2) == 0){
            result("el_token")
        }
        else{
            error("no login biatch")
        }
        
    }
    
    func register(credentials: [String : String], result: @escaping (_ data: String )->Void, error: @escaping (_ data: String )->Void){
        //http.post(url: <#T##String#>, data: credentials, success: (Dictionary<String, AnyObject>) -> Void, error: <#T##(Error) -> Void#>)
        
        if(arc4random_uniform(2) == 0){
            result("el_token")
        }
        else{
            error("can't register")
        }
    }
    
}
