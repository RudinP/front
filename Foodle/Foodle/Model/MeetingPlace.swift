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
    
    init(place: Place? = nil, time: Date? = nil) {
        self.place = place
        self.time = time
    }
}
