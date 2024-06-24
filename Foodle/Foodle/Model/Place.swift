//
//  Place.swift
//  Foodle
//
//  Created by 루딘 on 6/24/24.
//

import Foundation
import CoreLocation

class Place{
    var location: CLLocation?
    var placeName: String?
    var address: String?
    var distance: Int? //서버x
    var rate: Double?
    var reviewURL: String?
    var instaURL: String?
    var working: Dictionary = ["월": "", "화": "", "수": "", "목": "", "금": "", "토": "", "일": ""]
    var images: [String?] = []
    
    init(location: CLLocation? = nil, placeName: String? = nil, address: String? = nil, distance: Int? = nil, rate: Double? = nil, reviewURL: String? = nil, instaURL: String? = nil, working: Dictionary<String, String>, images: [String?]) {
        self.location = location
        self.placeName = placeName
        self.address = address
        self.distance = distance
        self.rate = rate
        self.reviewURL = reviewURL
        self.instaURL = instaURL
        self.working = working
        self.images = images
    }
}

