//
//  ServerResponse.swift
//  Foodle
//
//  Created by 루딘 on 8/12/24.
//

import Foundation

struct ServerResponse: Decodable{
    let data: [String:String]
    let success: Bool
    let error: String?
    let message: String?
    let status: Int?
}
