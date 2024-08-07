//
//  Friend.swift
//  Foodle
//
//  Created by 루딘 on 6/24/24.
//

import Foundation

var friends: [Friend]?
struct Friend : Codable{
    var user: User
    var like: Bool = false
}


