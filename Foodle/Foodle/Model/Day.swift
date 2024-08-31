//
//  Day.swift
//  Foodle
//
//  Created by 루딘 on 6/29/24.
//

import Foundation
enum Day: String, CaseIterable, Codable{
    case 월 = "월"
    case 화 = "화"
    case 수 = "수"
    case 목 = "목"
    case 금 = "금"
    case 토 = "토"
    case 일 = "일"
    
    init?(from string: String) {
        self.init(rawValue: string)
    }
}

let days = Day.allCases
