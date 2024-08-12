//
//  Meeting.swift
//  Foodle
//
//  Created by 루딘 on 6/24/24.
//

import Foundation

var meetings: [Meeting]?
var meetingsToday = getToday(meetings: meetings)
var meetingsUpcoming = getUpcoming(meetings: meetings)

struct Meeting:Codable{
    var mid: Int?
    var joiners: [User]?
    var name: String?
    var date: Date?
    var places: [MeetingPlace]?
}

extension Meeting{
    var dateString: String?{
        guard let date = date else {return nil}
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "YYYY/MM/dd (E)"
        return formatter.string(from: date)
    }
    var timeString: String?{
        guard let date = date else {return nil}
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "a h:mm"
        return formatter.string(from: date)
    }
    var dDay: String?{
        guard let date = date else {return nil}
        let calendar = Calendar.current
        
        let from = calendar.startOfDay(for: date)
        let to = calendar.startOfDay(for: Date())
        
        return "D" + String(calendar.dateComponents([.day], from: from, to: to).day!)
    }
}

func getToday(meetings: [Meeting]?, date: Date = Date()) -> [Meeting] {
    if let meetings{
        return meetings.filter {
        let today = date
        if let meetingday = $0.date{
            let calendar = Calendar.current
            return calendar.isDate(today, inSameDayAs: meetingday)
        }
        else {return false}
        }
    }
    return [Meeting]()
}

func getUpcoming(meetings: [Meeting]?) -> [Meeting] {
    if let meetings{
        return meetings.filter {
            let today = Date()
            if let meetingday = $0.date{
                let calendar = Calendar.current
                return !calendar.isDate(today, inSameDayAs: meetingday) && today < meetingday
            }
            else {return false}
        }
    }
    return [Meeting]()
}

