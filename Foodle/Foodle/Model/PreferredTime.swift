//
//  Preferrence.swift
//  Foodle
//
//  Created by 루딘 on 8/7/24.
//

import Foundation

struct PreferredTime: Codable{
    var day: Day
    var start: String
    var end: String 
}

extension PreferredTime{
    var startDate: Date{

        let timeString = start

        // DateFormatter 생성
        let dateFormatter = DateFormatter()

        // 시간 형식 설정 (시간만 입력된 경우)
        dateFormatter.dateFormat = "HH:mm"

        // 임의의 날짜를 추가하여 날짜+시간 형식으로 처리
        let dateWithTimeString = "2024-09-17 \(timeString)"
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"

        // 문자열을 Date 객체로 변환
        if let date = dateFormatter.date(from: dateWithTimeString) {
            return date
        } else {
            return Date()
        }

    }
    var endDate: Date{
        let timeString = end

        // DateFormatter 생성
        let dateFormatter = DateFormatter()

        // 시간 형식 설정 (시간만 입력된 경우)
        dateFormatter.dateFormat = "HH:mm"

        // 임의의 날짜를 추가하여 날짜+시간 형식으로 처리
        let dateWithTimeString = "2024-09-17 \(timeString)"
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"

        // 문자열을 Date 객체로 변환
        if let date = dateFormatter.date(from: dateWithTimeString) {
            return date
        } else {
            return Date()
        }
    }
}
