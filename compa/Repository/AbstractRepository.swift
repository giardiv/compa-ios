//
//  AbstractRepository.swift
//  compa
//
//  Created by m2sar on 14/05/2018.
//  Copyright © 2018 m2sar. All rights reserved.
//

import Foundation


protocol AbstractRepository {

    associatedtype T
    
    var http: HTTPService { get }
     
    func getAll(result: @escaping (_ data: [T] )->Void)
    func get(identifier:String, result: @escaping (_ data: T )->Void)
    func create(object: T, result: @escaping (_ data: Bool )->Void)
    func update(object: T, result: @escaping (_ data: Bool )->Void)
    func delete(object: T, result: @escaping (_ data: Bool )->Void)
    
}
