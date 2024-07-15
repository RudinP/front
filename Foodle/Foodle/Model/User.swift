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
}

let dummyUser = User(uid: "abcd", profileImage: "https://i.namu.wiki/i/j2Gz_JHE5A1MlSaglc2dyOecDVT0FXdjUbdzkPEjndZ9gsERUnl0G6rDs8d0LyOf2WeS71GS1yokVhs4EEcLVw.webp", name: "김푸들", nickName: "푸들푸들")

let dummyUser2 = User(uid: "efgh", profileImage: "https://i.namu.wiki/i/Uh6UAec7MjfLJvhydONNBXx3KVG_7zTqqWXhAEDtA5e6kNCoccKlDQh4Kpp2IsRuMeMhEkYYYqjWzzaUXPjQDA.webp", name: "박곰탕", nickName: "곰탕")

let dummyUser3 = User(uid: "hijk", profileImage: "https://i.namu.wiki/i/6hvrJEbrFWO3B1z6zYZGRmstoOwDn8g4bK2MqlH6vnVeIo8MFII4iaKIWmxN_CHVhYTLJdW9KheW7tE3_IIIldZ9kP9MU1IxLDWcKvcth2DgviC_fZmrb97i69hQM923f5otRwwc5LSEDLfa06h-Mw.webp", name: "강아지", nickName: "강강강아지")

let dummyUser4 = User(uid: "lmno", profileImage: "https://i.namu.wiki/i/jKIf6YS8CWOnXAIevJVUpp-8uA1EeKEasmydooBsTs0Rky5CFiDd4yb8Q-FcO8Q0sK7hHHdXY1f-vMm487edkMM94oDTgKPuhjLxqHjK_d3qyyweBmhYw0-QHTE7FrRgbGLtLH-th5ddoHpNSlzNRw.webp", name: "기니", nickName: "피그피그")

let dummyUser5 = User(uid: "pqrs", profileImage: "https://i.namu.wiki/i/dQ_YAwP3yv3MmQmLLi0Pglg1ndkW0geFQt4xuly-_vKuKFjU4Z4iCyUF8vyZxHlC64OZjwrg4B34XfFNZWCvCyCXUWeTY5JHVUW_9X8Do1zqch6Un7YrUwpFInSUZWQFyptqdclLwi2fb_VkPrtMKA.webp", name: "카피바라", nickName: "바라바라카피")

let dummyUser6 = User(uid: "tuvw", profileImage: "https://i.namu.wiki/i/Lt-VmNDgwuCQu5mFAkSKmKuSIyHJUlBsmfyXVVXEvEMtY-GnSJQzVmiO18SXnSsvGcm3km1kGOSYblEwTAO8UjJJhBLT_4-n5NyT-Fw_Dx4CubBS7QiD2Kx6_txxR14P7krnc-iddq_tdmbQd8g0wQ.webp", name: "돼지저금통", nickName: "저금통입니다")

let dummyUser7 = User(uid: "xyza", profileImage: "https://i.namu.wiki/i/U0KSNNW8UHYdThI4fHXzQ2WBaYV9_aikK8X-9vjYmbf2GeVYXOyxz479iGiuYrbt2Daslg75CZ7-wH-l3Oqc2utnNlukmGJjgMB7OXWX1lOOBvH-XUnGCa-tcZeAV_CpkZXzzd_3BBOft2Xk9eEoVg.webp", name: "시나모", nickName: "모롤롤")

