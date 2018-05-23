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
    let root: String
    
    init(http: HTTPService = HTTPService()) {
        self.http = http
        
        let path = Bundle.main.path(forResource: "Info", ofType: "plist")!
        let dict = NSDictionary(contentsOfFile: path)!
        root = dict["root"] as! String
    }
    
    func checkAuth(login : String, pwd : String, result: @escaping (_ data: String )->Void, error: @escaping (_ data: String )->Void){
        
        http.post(
            url: root + "/user/login",
            data: ["login": login, "password": pwd],
            success: { data in
                
                if let errorMsg = data["error"]{
                    error(errorMsg as! String)
                }
                else{
                    result(data["token"] as! String)
                }
            },
            error: { data in
                print("error in post request")
                //error(data)
            }
        )       
        
    }
    
    func register(credentials: [String : String], result: @escaping (_ data: String )->Void, error: @escaping (_ data: String )->Void){
        
        http.post(
            url: root + "/user/register",
            data: credentials,
            success: { data in
                
                if let errorMsg = data["detailMessage"]{
                    error(errorMsg as! String)
                }
                else{
                    result(data["token"] as! String)
                }
                
            },
            error: { data in
        
            }
        )

    }
    
}
