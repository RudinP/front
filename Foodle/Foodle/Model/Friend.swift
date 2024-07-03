//
//  Friend.swift
//  Foodle
//
//  Created by 루딘 on 6/24/24.
//

import Foundation

struct Friend : Codable{
    var user: User
    var like: Bool = false
}

let dummyFriends = [Friend(user: dummyUser2, like: true),
                    Friend(user: dummyUser3, like: false),
                    Friend(user: dummyUser4, like: false),
                    Friend(user: dummyUser5, like: true),
                    Friend(user: dummyUser6, like: true),
                    Friend(user: dummyUser7, like: false)]
