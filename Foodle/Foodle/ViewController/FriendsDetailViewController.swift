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
    var friendUid: String? 
    
    var upcomingMeetings: [Meeting] = []
    var placeLists: [PlaceList]?
    var selectedMeeting: Meeting?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = view.center
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
        
        if let friendsNameText = friendsNameText {
            friendsNameLabel.text = friendsNameText
        }
        
        if let profileImgUrl = profileImgUrl {
            profileImg.setImageFromStringURL(profileImgUrl)
        }
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        placeCollectionView.dataSource = self
        placeCollectionView.delegate = self
        
        fetchMeeting(user!.uid!) { meetings in
            DispatchQueue.global().async {
                if let meetings = meetings {
                    meetingsUpcoming = getUpcoming(meetings: meetings)
                    
                    self.upcomingMeetings = meetingsUpcoming.filter { meeting in
                        meeting.joiners?.contains(where: { $0.uid == self.friendUid }) ?? false
                    }
                    
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                        activityIndicator.stopAnimating()
                        activityIndicator.removeFromSuperview()
                    }
                }
            }
        }
        
        fetchPlaceLists(friendUid ?? "") { placeLists in
            DispatchQueue.main.async {
                self.placeLists = placeLists
                self.placeCollectionView.reloadData()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailMeetingFriends" {
            if let indexPath = collectionView.indexPathsForSelectedItems?.first {
                let selectedMeeting = upcomingMeetings[indexPath.item]
                
                if let destinationVC = segue.destination as? FriendMeetingDetailViewController {
                    destinationVC.selectedMeeting = selectedMeeting
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionView {
            return upcomingMeetings.count
        } else if collectionView == self.placeCollectionView {
            return placeLists?.flatMap { $0.places ?? [] }.count ?? 0
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
            
            let places = placeLists?.flatMap { $0.places ?? [] } ?? []
            let place = places[indexPath.item]
            
            if let imageUrlString = place.images?.first {
                cell.placeImg.setImageFromStringURL(imageUrlString)
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
    
    func setImageFromStringURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        self.placeImg.image = UIImage(data: data)
                    }
                }
            }
        }
    }
}
