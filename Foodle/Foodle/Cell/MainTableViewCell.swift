//
//  MainTableViewCell.swift
//  Foodle
//
//  Created by 루딘 on 3/14/24.
//

import UIKit

class MainTableViewCell: UITableViewCell {
    
    @IBOutlet weak var mainCollectionView: UICollectionView!
    var bgColor: UIColor?
    var textColor: UIColor?
    var section: Int?
    var index: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        mainCollectionView.dataSource = self
        mainCollectionView.delegate = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func prepare(bgColor: UIColor?, textColor: UIColor?){
        self.bgColor = bgColor
        self.textColor = textColor
        self.mainCollectionView.reloadData()
    }
    
    
}

extension MainTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch self.section {
        case 0:
            return dummyMeetings[index!].places.count
        case 1:
            return dummyMeetingsUpcoming[index!].places.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch self.section{
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mainCollectionViewCell", for: indexPath) as! MainCollectionViewCell
            let target = dummyMeetings[index!]
            cell.date.text = target.dateString
            cell.meetingName.text = target.name
            cell.order.text = "\(indexPath.item + 1)"
            cell.placeName.text = target.places[indexPath.item]?.place?.placeName
            cell.placeTime.text = target.places[indexPath.item]?.timeString
            cell.prepare(bgColor: self.bgColor ?? .secondAccent, textColor: textColor ?? .black)
            
            return cell
            
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "upcomingCell", for: indexPath) as! UpcomingCollectionViewCell
            let target = dummyMeetingsUpcoming[indexPath.row]
            cell.dDay.text = target.dDay
            cell.date.text = target.dateString
            cell.meetName.text = target.name
            cell.prepare()
            
            return cell
        default: return UICollectionViewCell()
        }
    }
    
    
}
