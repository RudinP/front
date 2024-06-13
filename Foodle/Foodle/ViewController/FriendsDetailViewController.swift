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
    
    var friendsNameText: String?
    var profileImgName: String?
    
    let scheList: [FriendsSchedule] = FriendsSchedule.list
    
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
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return scheList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendsScheduleCell", for: indexPath) as? FriendsScheduleCollectionViewCell else {
            fatalError("Unable to dequeue FriendsScheduleCollectionViewCell")
        }
        
        let schedule = scheList[indexPath.item]
        cell.friendsScheNameLabel.text = schedule.friendsScheName
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        cell.friendsScheDateLabel.text = dateFormatter.string(from: schedule.friendsScheDate)
                
        return cell
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

class FriendsScheduleCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var friendsScheDateLabel: UILabel!
    @IBOutlet weak var friendsScheNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 10
        layer.masksToBounds = true
    }
}
