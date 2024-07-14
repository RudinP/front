//
//  Meeting.swift
//  Foodle
//
//  Created by 루딘 on 6/24/24.
//

import Foundation

var meetings: [Meeting]?
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
    var dDay: String?{
        guard let date = date else {return nil}
        let calendar = Calendar.current
        
        let from = calendar.startOfDay(for: date)
        let to = calendar.startOfDay(for: Date())
        
        return "D" + String(calendar.dateComponents([.day], from: from, to: to).day!)
    }
}

func getToday(meetings: [Meeting], date: Date = Date()) -> [Meeting] {
    meetings.filter {
        let today = date
        if let meetingday = $0.date{
            let calendar = Calendar.current
            return calendar.isDate(today, inSameDayAs: meetingday)
        }
        else {return false}
    }
}

func getUpcoming(meetings: [Meeting]) -> [Meeting] {
    meetings.filter {
        let today = Date()
        if let meetingday = $0.date{
            let calendar = Calendar.current
            return !calendar.isDate(today, inSameDayAs: meetingday) && today < meetingday
        }
        else {return false}
    }
}

let dummyMeetings = [Meeting(mid: 1, joiners: [dummyUser, dummyUser2], name: "확인용 미팅", date: Date(), places: dummyMeetingPlaces),
                     Meeting(mid: 2,joiners: [dummyUser, dummyUser2], name: "확인용 미팅2", date: Date(), places: dummyMeetingPlaces),
                     Meeting(mid: 3, joiners: [dummyUser, dummyUser2], name: "확인용 미팅3", date: Date(), places: dummyMeetingPlaces), Meeting(joiners: [dummyUser, dummyUser2], name: "내일 미팅", date: Calendar.current.date(byAdding: .day, value: 1, to: Date())!, places: dummyMeetingPlaces),
                     Meeting(mid: 4, joiners: [dummyUser, dummyUser2], name: "내일 미팅2", date: Calendar.current.date(byAdding: .day, value: 1, to: Date())!, places: dummyMeetingPlaces),
                     Meeting(mid: 5, joiners: [dummyUser, dummyUser2], name: "내일 미팅3", date: Calendar.current.date(byAdding: .day, value: 1, to: Date())!, places: dummyMeetingPlaces)]
let dummyTodayMeetings = getToday(meetings: dummyMeetings)
let dummyMeetingsUpcoming = getUpcoming(meetings: dummyMeetings)
let dummyMeeting = Meeting(joiners: [], name: "", date: Date(), places: [])
