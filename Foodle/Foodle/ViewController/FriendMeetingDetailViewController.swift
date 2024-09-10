//
//  FriendMeetingDetailViewController.swift
//  Foodle
//
//  Created by 민정 on 9/4/24.
//

import UIKit
import MapKit

class FriendMeetingDetailViewController: UIViewController, CLLocationManagerDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    @IBOutlet weak var meetingName: UILabel!
    @IBOutlet weak var meetingDate: UILabel!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var fName: UICollectionView!
    @IBOutlet weak var meeting: UICollectionView!
    
    let locationManager = CLLocationManager()
    var selectedMeeting: Meeting?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        map.showsUserLocation = true

        fName.dataSource = self
        fName.delegate = self
        meeting.dataSource = self
        meeting.delegate = self

        if let selectedMeeting = selectedMeeting {
            meetingName.text = selectedMeeting.name ?? "Unknown Meeting Name"
            meetingDate.text = selectedMeeting.date.map { formatDateToString(date: $0) } ?? "Unknown Date"
            
            print("Received meeting: \(selectedMeeting.name ?? "Unknown Meeting Name")")
        } else {
            meetingName.text = "No Meeting"
            meetingDate.text = "No Date"
        }
        
        addAnnotationsForMeetingPlaces()
        updateUI()
    }
    
    func addAnnotationsForMeetingPlaces() {
        guard let places = selectedMeeting?.places else { return }

        for (index, meetingPlace) in places.enumerated() {
            guard let place = meetingPlace.place,
                  let latitude = place.latitude,
                  let longitude = place.longtitude else { continue }

            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            annotation.title = place.placeName
            annotation.subtitle = place.address
            map.addAnnotation(annotation)

            // 첫 번째 장소 위치로 지도 중심 설정
            if index == 0 {
                let region = MKCoordinateRegion(center: annotation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
                map.setRegion(region, animated: true)
            }
        }
    }
    
    func updateUI() {
        if let selectedMeeting = selectedMeeting {
            meetingName.text = selectedMeeting.name ?? "Unknown Meeting Name"
            meetingDate.text = selectedMeeting.date.map { formatDateToString(date: $0) } ?? "Unknown Date"
        } else {
            meetingName.text = "No Meeting"
            meetingDate.text = "No Date"
        }
    }

    func formatDateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        return dateFormatter.string(from: date)
    }
    
    func goLocation(latitudeValue: CLLocationDegrees, longitudeValue : CLLocationDegrees, delta span :Double) {
        let pLocation = CLLocationCoordinate2DMake(latitudeValue, longitudeValue)
        let spanValue = MKCoordinateSpan(latitudeDelta: span, longitudeDelta: span)
        let pRegion = MKCoordinateRegion(center: pLocation, span: spanValue)
        map.setRegion(pRegion, animated: true)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == fName {
            return selectedMeeting?.joiners?.count ?? 0
        } else if collectionView == meeting {
            return selectedMeeting?.places?.count ?? 0
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == fName {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MeetingFriendsNameCell2", for: indexPath) as! MeetingFriendsNameCell2
            if let joiners = selectedMeeting?.joiners {
                cell.nameLabel.text = joiners[indexPath.item].nickName
            }
            return cell
        } else if collectionView == meeting {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MeetingDetailCell2", for: indexPath) as! MeetingDetailCell2
                if let places = selectedMeeting?.places {
                    let detail = places[indexPath.item]
                    cell.numberLabel.text = "\(indexPath.item + 1)"
                    cell.placeLabel.text = detail.place?.placeName
                    cell.timeLabel.text = detail.timeString
                    cell.addressLabel.text = detail.place?.address
                }
            return cell
        }
        return UICollectionViewCell()
    }
}

class MeetingFriendsNameCell2: UICollectionViewCell {
    @IBOutlet weak var nameLabel: UILabel!
}

class MeetingDetailCell2: UICollectionViewCell {
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
}
