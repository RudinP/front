//
//  PlaceListAnnotation.swift
//  Foodle
//
//  Created by 루딘 on 7/30/24.
//

import Foundation
import MapKit
import CoreLocation

class PlaceListAnnotation: NSObject,MKAnnotation{
    var coordinate: CLLocationCoordinate2D
    let place: Place
    let color: UIColor
    
    init(coordinate: CLLocationCoordinate2D, place: Place, color: UIColor) {
        self.coordinate = coordinate
        self.place = place
        self.color = color
    }
    
    var title: String?{
        return place.placeName
    }
}
