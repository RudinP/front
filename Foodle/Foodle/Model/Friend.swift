//
//  Friend.swift
//  Foodle
//
//  Created by 루딘 on 6/24/24.
//

import Foundation

class Friend: User{
    var like: Bool?
    
    init(user: User, like: Bool? = nil) {
        super.init(user: user)
        self.like = like
    }
}
