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
    
    init(uid: String?, profileImage: String?, name: String?, nickName: String?) {
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

let dummyUser = User(uid: "abcd", profileImage: "https://i.namu.wiki/i/j2Gz_JHE5A1MlSaglc2dyOecDVT0FXdjUbdzkPEjndZ9gsERUnl0G6rDs8d0LyOf2WeS71GS1yokVhs4EEcLVw.webp", name: "김푸들", nickName: "푸들푸들")

let dummyUser2 = User(uid: "efgh", profileImage: "https://i.namu.wiki/i/Uh6UAec7MjfLJvhydONNBXx3KVG_7zTqqWXhAEDtA5e6kNCoccKlDQh4Kpp2IsRuMeMhEkYYYqjWzzaUXPjQDA.webp", name: "박곰탕", nickName: "곰탕")


