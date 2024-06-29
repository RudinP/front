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
    var working: Dictionary = [Day.월: "", Day.화: "", Day.수: "", Day.목: "", Day.금: "", Day.토: "", Day.일: ""] //서버에서 월화수목금토일에 맞춰 시간을 String 배열로 주세요. 만약 아예 값이 없다면 - 를 넘겨주세요.
    var breakTime: Dictionary = [Day.월: "", Day.화: "", Day.수: "", Day.목: "", Day.금: "", Day.토: "", Day.일: ""]
    var close: [Day]? {
        var result: [Day]?
        for time in working{
            if time.value.isEmpty{
                result?.append(time.key)
            }
        }
        return result
    }
    var images: [String?] = []
    
    init(location: CLLocation, placeName: String, address: String, distance: Int, rate: Double?, reviewURL: String?, instaURL: String?, working: [String?], breakTime: [String?], images: [String?]) {
        self.location = location
        self.placeName = placeName
        self.address = address
        self.distance = distance
        self.rate = rate
        self.reviewURL = reviewURL
        self.instaURL = instaURL
        
        for i in 0...6{
            self.working.updateValue(working[i] ?? "", forKey: days[i])
            self.breakTime.updateValue(breakTime[i] ?? "", forKey: days[i])
        }
        self.images = images
    }
}

let dummyPlaces: [Place] = [
    Place(location: CLLocation(), placeName: "장소1", address: "경기도 수원시 영통구 어쩌구", distance: 500, rate: 4.5, reviewURL: "https://www.naver.com", instaURL: "https://www.naver.com", working: ["10:00~13:00","10:00~13:00","10:00~13:00","10:00~13:00","10:00~13:00","10:00~13:00","10:00~13:00"], breakTime: ["10:00~13:00","10:00~13:00","10:00~13:00","10:00~13:00","10:00~13:00","10:00~13:00","10:00~13:00"], images: ["https://search.pstatic.net/common/?src=https%3A%2F%2Fldb-phinf.pstatic.net%2F20190829_73%2F1567055108272gpOOC_JPEG%2FU4WOfRsgMaItW5HIhgOA5tJI.jpg","https://search.pstatic.net/common/?src=https%3A%2F%2Fldb-phinf.pstatic.net%2F20190829_73%2F1567055108272gpOOC_JPEG%2FU4WOfRsgMaItW5HIhgOA5tJI.jpg"]),
    Place(location: CLLocation(), placeName: "장소2", address: "경기도 수원시 영통구 어쩌구", distance: 500, rate: 4.5, reviewURL: "https://www.naver.com", instaURL: "https://www.naver.com", working: ["10:00~13:00","10:00~13:00","10:00~13:00","10:00~13:00","10:00~13:00","10:00~13:00","10:00~13:00"], breakTime: ["10:00~13:00","10:00~13:00","10:00~13:00","10:00~13:00","10:00~13:00","10:00~13:00","10:00~13:00"], images: ["https://search.pstatic.net/common/?src=https%3A%2F%2Fldb-phinf.pstatic.net%2F20190829_73%2F1567055108272gpOOC_JPEG%2FU4WOfRsgMaItW5HIhgOA5tJI.jpg","https://search.pstatic.net/common/?src=https%3A%2F%2Fldb-phinf.pstatic.net%2F20190829_73%2F1567055108272gpOOC_JPEG%2FU4WOfRsgMaItW5HIhgOA5tJI.jpg"])
]

