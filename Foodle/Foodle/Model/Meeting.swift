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
    var places: [MeetingPlace?] = []
    
    init(joiners: [User], name: String, date: Date, places: [MeetingPlace?]) {
        self.joiners = joiners
        self.name = name
        self.date = date
        self.places = places
    }
}

let dummyMeeting = Meeting(joiners: [dummyUser, dummyUser2], name: "확인용 미팅", date: Date(), places: dummyMeetingPlaces)
