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
     
    func getAll() -> [T]
    func get(identifier:Int) -> T?
    func create(object: T) -> Bool
    func update(object: T) -> Bool
    func delete(object: T) -> Bool
    
}
