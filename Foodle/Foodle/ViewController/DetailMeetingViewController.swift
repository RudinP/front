//
//  DetailMeetingViewController.swift
//  Foodle
//
//  Created by 민정 on 6/23/24.
//

import UIKit
import MapKit

class DetailMeetingViewController: UIViewController, CLLocationManagerDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    @IBOutlet weak var meetingName: UILabel!
    @IBOutlet weak var meetingDate: UILabel!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var fName: UICollectionView!
    @IBOutlet weak var meeting: UICollectionView!
    
    let locationManager = CLLocationManager()
    
    let friendsNames = ["김지현", "박진희", "정민정", "김지현", "박진희", "정민정"]
    let meetingDetails = [
        (number: "1", place: "스타벅스", time: "10:00 AM"),
        (number: "2", place: "도서관", time: "11:00 AM"),
        (number: "3", place: "학생회관", time: "2:00 PM")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // locationManager.requestWhenInUseAuthorization() // 위치 승인 요청
        locationManager.startUpdatingLocation()
        map.showsUserLocation = true
        
        fName.dataSource = self
        fName.delegate = self
        meeting.dataSource = self
        meeting.delegate = self
    }
    
    func goLocation(latitudeValue: CLLocationDegrees, longitudeValue : CLLocationDegrees, delta span :Double) {
        let pLocation = CLLocationCoordinate2DMake(latitudeValue, longitudeValue)
        let spanValue = MKCoordinateSpan(latitudeDelta: span, longitudeDelta: span)
        let pRegion = MKCoordinateRegion(center: pLocation, span: spanValue)
        map.setRegion(pRegion, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        let pLocation = locations.last
        goLocation(latitudeValue: (pLocation?.coordinate.latitude)!, longitudeValue: (pLocation?.coordinate.longitude)!, delta: 0.01)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == fName {
            return friendsNames.count
        } else if collectionView == meeting {
            return meetingDetails.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == fName {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MeetingFriendsNameCell", for: indexPath) as! MeetingFriendsNameCell
            cell.nameLabel.text = friendsNames[indexPath.item]
            return cell
        } else if collectionView == meeting {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MeetingDetailCell", for: indexPath) as! MeetingDetailCell
            let detail = meetingDetails[indexPath.item]
            cell.numberLabel.text = detail.number
            cell.placeLabel.text = detail.place
            cell.timeLabel.text = detail.time
            return cell
        }
        return UICollectionViewCell()
    }
}

class MeetingFriendsNameCell: UICollectionViewCell {
    @IBOutlet weak var nameLabel: UILabel!
}


class MeetingDetailCell: UICollectionViewCell {
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
}
