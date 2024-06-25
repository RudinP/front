//
//  Friend.swift
//  Foodle
//
//  Created by 루딘 on 6/24/24.
//

import Foundation

class Friend: User{
    var like: Bool = false
    
    init(user: User, like: Bool) {
        super.init(user: user)
        self.like = like
    }
}

let dummyFriends = [Friend(user: dummyUser2, like: true)]
