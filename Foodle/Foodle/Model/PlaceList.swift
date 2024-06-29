//
//  PlaceList.swift
//  Foodle
//
//  Created by 루딘 on 6/24/24.
//

import Foundation
import CoreGraphics
import UIKit

class PlaceList{
    var listID: Int?
    var name: String?
    var color: UIColor?
    var places: [Place]?
    
    init(listID: Int, name: String, color: CGColor, places: [Place]?) {
        self.listID = listID
        self.name = name
        self.color = UIColor(cgColor: color)
        self.places = places
    }
}

let dummyPlaceLists = [PlaceList(listID: 0, name: "리스트 이름", color: UIColor.accent.cgColor, places: dummyPlaces)]
