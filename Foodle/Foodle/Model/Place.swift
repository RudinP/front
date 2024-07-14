//
//  Place.swift
//  Foodle
//
//  Created by 루딘 on 6/24/24.
//

import Foundation

struct Place: Codable{
    var longtitude: Double?
    var latitude: Double?
    var placeName: String?
    var address: String?
    var tel: String?
    var rate: Double?
    var reviewURL: String?
    var instaURL: String?
    var working: [String]?
    var breakTime: [String]?
    var images: [String]?
    var category: String?
}

extension Place{
    var workingDay: Dictionary<Day, String> {
        var dict = [Day.월: "", Day.화: "", Day.수: "", Day.목: "", Day.금: "", Day.토: "", Day.일: ""]
        for i in 0...6{
            dict.updateValue(working?[i] ?? "", forKey: days[i])
        }
        
        return dict
    }
    var breakTimeDay: Dictionary<Day, String>{
        var dict = [Day.월: "", Day.화: "", Day.수: "", Day.목: "", Day.금: "", Day.토: "", Day.일: ""]
        for i in 0...6{
            dict.updateValue(breakTime?[i] ?? "", forKey: days[i])
        }
        return dict
    }

    var distance: String {
        return "0m"
    }
    
    var close: String {
        var result = ""
        for time in workingDay{
            if time.value.isEmpty{
                result.append("\(time.key.rawValue) ")
            }
        }
        if result.isEmpty{
            result.append("없음")
        }
        return result
    }
    
    var isWorking: String{
        var result = "영업종료"
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        formatter.locale = Locale(identifier: "ko_KR")
        let today = Day(rawValue: formatter.string(from: now))
        formatter.dateFormat = "HH:mm"
        let nowTime = formatter.string(from: now)
        if let today {
            let workingTime = workingDay[today]?.components(separatedBy: ["~", " "])
            let bTime = breakTimeDay[today]?.components(separatedBy: ["~", " "])
            if let workingTime{
                if workingTime[0] <= nowTime && workingTime[1] >= nowTime {
                    result = "영업중"
                }
            }
            if let bTime{
                if bTime[0] <= nowTime && bTime[1] >= nowTime{
                    result = "브레이크타임"
                }
            }
        }
        return result
    }
    
    func getIsStarred() -> Bool{
        var result = false
        for placeList in dummyPlaceLists{
            if let place = placeList.places{
                result = place.contains(where: {
                    $0.isEqual(self)
                })
                if result {return result}
            }
        }
        return result
    }
    
    func isEqual(_ place: Place) -> Bool{
        return self.placeName == place.placeName && self.longtitude == place.longtitude && self.latitude == place.latitude
    }
}

let dummyPlaces: [Place] = [
    Place(longtitude: 23.2323,latitude: 23.2323, placeName: "장소1", address: "경기도 수원시 영통구 어쩌구", rate: 4.5, reviewURL: "https://www.naver.com", instaURL: "https://www.naver.com", working: ["10:00~23:00","10:00~23:00","10:00~23:00","10:00~23:00","10:00~23:00","10:00~23:00","10:00~23:00"], breakTime: ["16:00~17:00","16:00~17:00","16:00~17:00","16:00~17:00","16:00~17:00","16:00~17:00","16:00~17:00"], images: ["https://search.pstatic.net/common/?src=https%3A%2F%2Fldb-phinf.pstatic.net%2F20190829_73%2F1567055108272gpOOC_JPEG%2FU4WOfRsgMaItW5HIhgOA5tJI.jpg","https://search.pstatic.net/common/?src=https%3A%2F%2Fldb-phinf.pstatic.net%2F20190829_73%2F1567055108272gpOOC_JPEG%2FU4WOfRsgMaItW5HIhgOA5tJI.jpg"], category: "음식점"),
    Place(longtitude: 23.2323,latitude: 23.2323, placeName: "장소2", address: "경기도 수원시 영통구 어쩌구", rate: 4.5, reviewURL: "https://www.naver.com", instaURL: "https://www.naver.com", working: ["10:00~13:00","10:00~13:00","10:00~13:00","10:00~13:00","10:00~13:00","10:00~13:00","10:00~13:00"], breakTime: ["10:00~13:00","10:00~13:00","10:00~13:00","10:00~13:00","10:00~13:00","10:00~13:00","10:00~13:00"], images: ["https://search.pstatic.net/common/?src=https%3A%2F%2Fldb-phinf.pstatic.net%2F20190829_73%2F1567055108272gpOOC_JPEG%2FU4WOfRsgMaItW5HIhgOA5tJI.jpg","https://search.pstatic.net/common/?src=https%3A%2F%2Fldb-phinf.pstatic.net%2F20190829_73%2F1567055108272gpOOC_JPEG%2FU4WOfRsgMaItW5HIhgOA5tJI.jpg"], category: "음식점")
]

