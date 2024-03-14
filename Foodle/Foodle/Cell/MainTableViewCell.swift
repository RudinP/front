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
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch self.section{
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mainCollectionViewCell", for: indexPath) as? MainCollectionViewCell else { return UICollectionViewCell()}
            cell.date.text = "2001/04/11"
            cell.meetingName.text = "제생일입니다^^"
            cell.order.text = "\(indexPath.item + 1)"
            cell.placeName.text = "숙명여자 대학교"
            cell.placeTime.text = "2:00 AM"
            cell.prepare(bgColor: self.bgColor ?? .secondAccent, textColor: textColor ?? .black)
            
            return cell
            
        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "upcomingCell", for: indexPath) as? UpcomingCollectionViewCell else {return UICollectionViewCell()}
            cell.dDay.text = "D-232324"
            cell.date.text = "2024/1/1"
            cell.meetName.text = "아무래도졸업을해야하는 모임"
            cell.prepare()
            
            return cell
        default: return UICollectionViewCell()
        }
    }
    
    
}
