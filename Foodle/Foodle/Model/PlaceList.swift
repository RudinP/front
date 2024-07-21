//
//  PlaceList.swift
//  Foodle
//
//  Created by 루딘 on 6/24/24.
//

import Foundation
import CoreGraphics
import UIKit

var placeLists: [PlaceList]?
struct PlaceList: Codable{
    var lid: Int?
    var uid: String?
    var name: String?
    var color: String?
    var places: [Place]?
}

extension PlaceList{
    mutating func addPlace(_ place: Place?){
        if let place, let places{
            if !places.contains(where: {
                $0.isEqual(place)
            }){
                self.places?.append(place)
            }
        }
    }
    
    mutating func removePlace(_ place: Place?){
        if let place{
            self.places?.removeAll(where: {
                $0.isEqual(place)
            })
        }
    }
}
var dummyPlaceLists = [PlaceList(lid: 0, name: "리스트 이름", color: "", places: dummyPlaces),
                       PlaceList(lid: 1, name: "리스트 이름2", color: "", places: [Place]())]
