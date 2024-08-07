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
