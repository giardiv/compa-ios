//
//  FriendshipRepository.swift
//  compa
//
//  Created by m2sar on 01/06/2018.
//  Copyright © 2018 m2sar. All rights reserved.
//

import Foundation

class FriendshipRepository{
    
    let http: HTTPService = HTTPService()
    
    func setFriendshipStatus(friendId: String, status: String, result: @escaping (_ data: [String:Any]) -> Void, error: @escaping (_ data: [String:Any]) -> Void) {
        
        http.put(isRelative: true,
            isAuthenticated: true,
            url: "/friend",
            data: [
                "status": status,
                "friend_id": friendId
            ],
            success: <#T##([String : Any]) -> Void#>,
            error: <#T##([String : Any]) -> Void#>)
    }
    
    func confirmFriendshipRequest(friendId: String, result: @escaping (_ data: [String:Any]) -> Void, error: @escaping (_ data: [String:Any]) -> Void){
        self.setFriendshipStatus(friendId: friendId, status: "Accepted", result: result, error: error)
    }
    
    
}



