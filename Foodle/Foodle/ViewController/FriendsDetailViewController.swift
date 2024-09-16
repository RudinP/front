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
    @IBOutlet weak var likeWordLabel: UILabel!
    @IBOutlet weak var dislikeWordLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet var placeCollectionView: UICollectionView!
    
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var label4: UILabel!
    @IBOutlet weak var label5: UILabel!
    var scrollView: UIScrollView!
    
    var friendsNameText: String?
    var profileImgUrl: String?
    var friendUid: String? 
    var friendLikeWord: [String]?
    var friendDislikeWord: [String]?
    var friendTime: [PreferredTime]?
    
    var upcomingMeetings: [Meeting] = []
    var placeLists: [PlaceList]?
    var selectedMeeting: Meeting?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScrollView()
        
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
        
        if let friendLikeWord = friendLikeWord {
            likeWordLabel.text = friendLikeWord.joined(separator: ", ")
        }
        
        if let friendDislikeWord = friendDislikeWord {
            dislikeWordLabel.text = friendDislikeWord.joined(separator: ", ")
        }
        
        if let friendTime = friendTime {
            var timeText = ""
            for time in friendTime {
                if time.start != "00:00" && time.end != "00:00" {
                    let dayString = dayToString(day: time.day)
                    timeText += "\(dayString) \(time.start) ~ \(time.end)\n"
                }
            }
            timeLabel.numberOfLines = 0
            timeLabel.text = timeText.trimmingCharacters(in: .whitespacesAndNewlines)
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
    
    func setupScrollView() {
        scrollView = UIScrollView(frame: view.bounds)
        view.addSubview(scrollView)
        
        scrollView.addSubview(friendsNameLabel)
        scrollView.addSubview(profileImg)
        scrollView.addSubview(label1)
        scrollView.addSubview(collectionView)
        scrollView.addSubview(label2)
        scrollView.addSubview(likeWordLabel)
        scrollView.addSubview(label3)
        scrollView.addSubview(label4)
        scrollView.addSubview(label5)
        scrollView.addSubview(dislikeWordLabel)
        scrollView.addSubview(timeLabel)
        scrollView.addSubview(placeCollectionView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let contentHeight = timeLabel.frame.origin.y + timeLabel.frame.size.height + 90
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: contentHeight)
    }

    func dayToString(day: Day) -> String {
        switch day {
        case .월:
            return "월요일"
        case .화:
            return "화요일"
        case .수:
            return "수요일"
        case .목:
            return "목요일"
        case .금:
            return "금요일"
        case .토:
            return "토요일"
        case .일:
            return "일요일"
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
