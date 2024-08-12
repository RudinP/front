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
    var selectedMeeting: Meeting?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let editButton = UIBarButtonItem(title: "편집", style: .plain, target: self, action: #selector(nextButtonTapped))
        navigationItem.rightBarButtonItem = editButton
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        map.showsUserLocation = true
        
        fName.dataSource = self
        fName.delegate = self
        meeting.dataSource = self
        meeting.delegate = self
        
        guard let selectedMeeting else {return}
        meetingName.text = selectedMeeting.name
        if let date = selectedMeeting.date {
            meetingDate.text = formatDateToString(date: date)
        }
    }
    
    func formatDateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        return dateFormatter.string(from: date)
    }
    
    @objc func nextButtonTapped() {
        performSegue(withIdentifier: "EditMeeting", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditMeeting" {
            if let editVC = segue.destination as? EditMeetingViewController {
                let editableMeeting = EditableMeeting(origin: selectedMeeting)
                editVC.editableMeeting = editableMeeting
            }
        }
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
            return selectedMeeting?.joiners?.count ?? 0
        } else if collectionView == meeting {
            return selectedMeeting?.places?.count ?? 0
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == fName {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MeetingFriendsNameCell", for: indexPath) as! MeetingFriendsNameCell
            if let joiners = selectedMeeting?.joiners {
                cell.nameLabel.text = joiners[indexPath.item].nickName
            }
            return cell
        } else if collectionView == meeting {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MeetingDetailCell", for: indexPath) as! MeetingDetailCell
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

class MeetingFriendsNameCell: UICollectionViewCell {
    @IBOutlet weak var nameLabel: UILabel!
}

class MeetingDetailCell: UICollectionViewCell {
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
}
