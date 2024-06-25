//
//  Meeting.swift
//  Foodle
//
//  Created by 루딘 on 6/24/24.
//

import Foundation

class Meeting{
    var joiners: [User?] = []
    var name: String?
    var date: Date?
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
    var places: [MeetingPlace?] = []
    
    init(joiners: [User], name: String, date: Date, places: [MeetingPlace?]) {
        self.joiners = joiners
        self.name = name
        self.date = date
        self.places = places
    }
}

let dummyMeetings = [Meeting(joiners: [dummyUser, dummyUser2], name: "확인용 미팅", date: Date(), places: dummyMeetingPlaces),
                    Meeting(joiners: [dummyUser, dummyUser2], name: "확인용 미팅2", date: Date(), places: dummyMeetingPlaces),
                    Meeting(joiners: [dummyUser, dummyUser2], name: "확인용 미팅3", date: Date(), places: dummyMeetingPlaces)]
let dummyMeetingsUpcoming = [Meeting(joiners: [dummyUser, dummyUser2], name: "내일 미팅", date: Calendar.current.date(byAdding: .day, value: 1, to: Date())!, places: dummyMeetingPlaces),
                             Meeting(joiners: [dummyUser, dummyUser2], name: "내일 미팅2", date: Calendar.current.date(byAdding: .day, value: 1, to: Date())!, places: dummyMeetingPlaces),
                             Meeting(joiners: [dummyUser, dummyUser2], name: "내일 미팅3", date: Calendar.current.date(byAdding: .day, value: 1, to: Date())!, places: dummyMeetingPlaces)]
