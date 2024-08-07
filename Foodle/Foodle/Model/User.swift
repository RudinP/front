//
//  User.swift
//  Foodle
//
//  Created by 루딘 on 6/24/24.
//

import Foundation

var user: User?
struct User: Codable{
    var uid: String?
    var profileImage: String?
    var name: String?
    var nickName: String?
    var preferredTime: PreferredTime?
    var likeWord: [String]?
    var dislikeWord: [String]?
}

