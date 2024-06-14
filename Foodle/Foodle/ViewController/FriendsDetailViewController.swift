//
//  FriendsDetailViewController.swift
//  Foodle
//
//  Created by 민정 on 6/10/24.
//

import UIKit

class FriendsDetailViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    @IBOutlet var friendsNameLabel: UILabel!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var placeCollectionView: UICollectionView!
    
    var friendsNameText: String?
    var profileImgName: String?
    
    let scheList: [FriendsSchedule] = FriendsSchedule.list
    let placeList: [FriendsPlace] = FriendsPlace.list
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let friendsNameText = friendsNameText {
            friendsNameLabel.text = friendsNameText
        }
        
        if let profileImgName = profileImgName {
            profileImg.image = UIImage(named: profileImgName)
        }
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        placeCollectionView.dataSource = self
        placeCollectionView.delegate = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionView {
            return scheList.count
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
            
            let schedule = scheList[indexPath.item]
            cell.friendsScheNameLabel.text = schedule.friendsScheName
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy/MM/dd"
            cell.friendsScheDateLabel.text = dateFormatter.string(from: schedule.friendsScheDate)
                    
            return cell
        } else if collectionView == self.placeCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "placeCell", for: indexPath) as? PlaceCollectionViewCell else {
                fatalError("Unable to dequeue PlaceCollectionViewCell")
            }
            
            let place = placeList[indexPath.item]
            cell.placeImg.image = UIImage(named: place.imageName)
            cell.placeName.text = place.name
            
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
}

struct FriendsSchedule {
    let friendsScheDate: Date
    let friendsScheName: String
}

extension FriendsSchedule {
    static let list: [FriendsSchedule] = [
        FriendsSchedule(friendsScheDate: Calendar.current.date(from: DateComponents(year: 2024, month: 5, day: 26))!, friendsScheName: "고등학교 동창회"),
        FriendsSchedule(friendsScheDate: Calendar.current.date(from: DateComponents(year: 2024, month: 5, day: 27))!, friendsScheName: "친구 결혼식"),
        FriendsSchedule(friendsScheDate: Calendar.current.date(from: DateComponents(year: 2024, month: 5, day: 28))!, friendsScheName: "회사 미팅"),
        FriendsSchedule(friendsScheDate: Calendar.current.date(from: DateComponents(year: 2024, month: 5, day: 28))!, friendsScheName: "맛집 탐방")
    ]
}

struct FriendsPlace {
    let imageName: String
    let name: String
}

extension FriendsPlace {
    static let list: [FriendsPlace] = [
        FriendsPlace(imageName: "dummy", name: "금별맥주"),
        FriendsPlace(imageName: "dummy", name: "스타벅스"),
        FriendsPlace(imageName: "dummy", name: "메가커피")
    ]
}

class FriendsScheduleCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var friendsScheDateLabel: UILabel!
    @IBOutlet weak var friendsScheNameLabel: UILabel!
}

class PlaceCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var placeImg: UIImageView!
    @IBOutlet weak var placeName: UILabel!
    @IBOutlet weak var placeButton: UIButton!
}
