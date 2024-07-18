//
//  MeetingPlace.swift
//  Foodle
//
//  Created by 루딘 on 6/24/24.
//

import Foundation

struct MeetingPlace: Codable{
    var place: Place?
    var time: Date?
}

extension MeetingPlace{
    var timeString: String?{
        guard let time = time else { return nil }
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: time)
    }
}

let dummyMeetingPlaces = [MeetingPlace(place: dummyPlaces[0], time: Date()), MeetingPlace(place: dummyPlaces[1], time: Date())]
let dummyMeetingPlaces2 = [MeetingPlace(place: dummyPlaces[0], time: Date()), MeetingPlace(place: dummyPlaces[1], time: Date()), MeetingPlace(place: dummyPlaces[2], time: Date())]
