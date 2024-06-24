//
//  PlaceList.swift
//  Foodle
//
//  Created by 루딘 on 6/24/24.
//

import Foundation
import CoreGraphics

class PlaceList{
    var listID: Int?
    var name: String?
    var color: CGColor?
    var places: [Place?] = []
    
    init(listID: Int? = nil, name: String? = nil, color: CGColor? = nil, places: [Place?]) {
        self.listID = listID
        self.name = name
        self.color = color
        self.places = places
    }
}
