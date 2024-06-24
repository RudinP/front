//
//  Meeting.swift
//  Foodle
//
//  Created by 루딘 on 6/24/24.
//

import Foundation

class Meeting{
    var joiners: [Friend?] = []
    var name: String?
    var date: Date?
    var places: [MeetingPlace?] = []
    
    init(joiners: [Friend?], name: String? = nil, date: Date? = nil, places: [MeetingPlace?]) {
        self.joiners = joiners
        self.name = name
        self.date = date
        self.places = places
    }
}
