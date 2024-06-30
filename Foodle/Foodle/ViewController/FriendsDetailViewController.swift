//
//  FriendsDetailViewController.swift
//  Foodle
//
//  Created by 민정 on 6/10/24.
//

import UIKit

class FriendsDetailViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    @IBOutlet var friendsNameLabel: UILabel!
    @IBOutlet var profileImg: UIImageView!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var placeCollectionView: UICollectionView!
    
    var friendsNameText: String?
    var profileImgUrl: String?
    
    let upcomingMeetings: [Meeting] = dummyMeetingsUpcoming
    let placeList: [Place] = dummyPlaces
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let friendsNameText = friendsNameText {
            friendsNameLabel.text = friendsNameText
        }
        
        if let profileImgUrl = profileImgUrl, let url = URL(string: profileImgUrl) {
            if let data = try? Data(contentsOf: url) {
                profileImg.image = UIImage(data: data)
            }
        }
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        placeCollectionView.dataSource = self
        placeCollectionView.delegate = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionView {
            return upcomingMeetings.count
        } else if collectionView == self.placeCollectionView {
            return placeList.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.collectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendsScheduleCell", for: indexPath) as? FriendsScheduleCollectionViewCell else {
                fatalError("Unable to dequeue FriendsScheduleCollectionViewCell")
            }
            
            let meeting = upcomingMeetings[indexPath.item]
            cell.meetingNameLabel.text = meeting.name
            
            if let dateString = meeting.dateString {
                cell.meetingDateLabel.text = dateString
            }
            
            return cell
        } else if collectionView == self.placeCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "placeCell", for: indexPath) as? PlaceCollectionViewCell else {
                fatalError("Unable to dequeue PlaceCollectionViewCell")
            }
            
            let place = placeList[indexPath.item]
            
            if let imageUrlString = place.images?.first, let url = URL(string: imageUrlString), let data = try? Data(contentsOf: url) {
                cell.placeImg.image = UIImage(data: data)
            }
            
            cell.placeName.text = place.placeName
            
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
}

class FriendsScheduleCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var meetingNameLabel: UILabel!
    @IBOutlet weak var meetingDateLabel: UILabel!
}

class PlaceCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var placeImg: UIImageView!
    @IBOutlet weak var placeName: UILabel!
    @IBOutlet weak var placeButton: UIButton!
}
