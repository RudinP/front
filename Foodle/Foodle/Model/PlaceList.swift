//
//  PlaceList.swift
//  Foodle
//
//  Created by 루딘 on 6/24/24.
//

import Foundation
import CoreGraphics
import UIKit

struct PlaceList: Codable{
    var listID: Int?
    var name: String?
    var color: String?
    var places: [Place]?
}

let dummyPlaceLists = [PlaceList(listID: 0, name: "리스트 이름", color: "", places: dummyPlaces),
                       PlaceList(listID: 1, name: "리스트 이름2", color: "")]
