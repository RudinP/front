//
//  Day.swift
//  Foodle
//
//  Created by 루딘 on 6/29/24.
//

import Foundation
enum Day: String, CaseIterable, Codable{
    case 월
    case 화
    case 수
    case 목
    case 금
    case 토
    case 일
}

let days = Day.allCases
