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
            success: result,
            error: error)
    }
    
    func confirmFriendshipRequest(friendId: String, result: @escaping (_ data: [String:Any]) -> Void, error: @escaping (_ data: [String:Any]) -> Void){
        self.setFriendshipStatus(friendId: friendId, status: "Accepted", result: result, error: error)
    }
    
    func rejectFriendshipRequest(friendId: String, result: @escaping (_ data: [String:Any]) -> Void, error: @escaping (_ data: [String:Any]) -> Void){
        self.setFriendshipStatus(friendId: friendId, status: "Refused", result: result, error: error)
    }
    
    func blockUser(friendId: String, result: @escaping (_ data: [String:Any]) -> Void, error: @escaping (_ data: [String:Any]) -> Void){
        self.setFriendshipStatus(friendId: friendId, status: "Blocker", result: result, error: error)
    }
    
    func deblockUser(friendId: String, result: @escaping (_ data: [String:Any]) -> Void, error: @escaping (_ data: [String:Any]) -> Void){
        self.setFriendshipStatus(friendId: friendId, status: "Accepted", result: result, error: error)
    }
    
    func deleteFriendship(friendId: String, result: @escaping (_ data: [String:Any]) -> Void, error: @escaping (_ data: [String:Any]) -> Void) {
        http.delete(isRelative: true,
                    isAuthenticated: true,
                    url: "/friend",
                    data: ["friend_id" : friendId],
                    success: result,
                    error: error)
    }
    
    
}



