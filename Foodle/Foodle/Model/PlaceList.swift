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
