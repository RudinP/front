//
//  User.swift
//  Foodle
//
//  Created by 루딘 on 6/24/24.
//

import Foundation

class User{
    var uid: String?
    var profileImage: String?
    var name: String?
    var nickName: String?
    
    init(uid: String? = nil, profileImage: String? = nil, name: String? = nil, nickName: String? = nil) {
        self.uid = uid
        self.profileImage = profileImage
        self.name = name
        self.nickName = nickName
    }
    
    init(user: User){
        self.uid = user.uid
        self.profileImage = user.profileImage
        self.name = user.name
        self.nickName = user.nickName
    }
}

