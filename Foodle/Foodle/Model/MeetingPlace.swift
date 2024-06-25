//
//  MeetingPlace.swift
//  Foodle
//
//  Created by 루딘 on 6/24/24.
//

import Foundation

class MeetingPlace{
    var place: Place?
    var time: Date?
    var timeString: String?{
        guard let time = time else { return nil }
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: time)
    }
    
    init(place: Place, time: Date?) {
        self.place = place
        self.time = time
    }
}

let dummyMeetingPlaces = [MeetingPlace(place: dummyPlaces[0], time: Date()), MeetingPlace(place: dummyPlaces[1], time: Date())]
