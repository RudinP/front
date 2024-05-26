//
//  ScheduleListViewController.swift
//  Foodle
//
//  Created by 민정 on 5/16/24.
//

import UIKit

class ScheduleListViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate{
    let scheList: [Schedule] = Schedule.list
    
    @IBOutlet weak var scheListLabel: UILabel!
    @IBOutlet weak var calendar: UIDatePicker!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return scheList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ScheduleCell", for: indexPath) as? ScheduleCollectionViewCell else {
            fatalError("Unable to dequeue ScheduleCollectionViewCell")
            }
        
        let schedule = scheList[indexPath.item]
        cell.scheNameLabel.text = schedule.scheName
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        cell.scheDateLabel.text = dateFormatter.string(from: schedule.scheDate)
                
        return cell
    }
}

struct Schedule {
    let scheDate: Date
    let scheName: String
}

extension Schedule {
    static let list: [Schedule] = [
        Schedule(scheDate: Calendar.current.date(from: DateComponents(year: 2024, month: 5, day: 26))!, scheName: "고등학교 동창회"),
        Schedule(scheDate: Calendar.current.date(from: DateComponents(year: 2024, month: 5, day: 27))!, scheName: "친구 결혼식"),
        Schedule(scheDate: Calendar.current.date(from: DateComponents(year: 2024, month: 5, day: 28))!, scheName: "회사 미팅"),
        Schedule(scheDate: Calendar.current.date(from: DateComponents(year: 2024, month: 5, day: 28))!, scheName: "맛집 탐방")
    ]
}

class ScheduleCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var scheDateLabel: UILabel!
    @IBOutlet weak var scheNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 10
        layer.masksToBounds = true
    }
}
