//
//  ScheduleListViewController.swift
//  Foodle
//
//  Created by 민정 on 5/16/24.
//

import UIKit

class ScheduleListViewController: UIViewController{
    @IBOutlet weak var calendar: UIDatePicker!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var date = Date()
    
    @IBAction func selectedDate(_ sender: UIDatePicker) {
        date = sender.date
        collectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        calendar.date = date
    }
}

extension ScheduleListViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return getToday(meetings: meetings, date: date).count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ScheduleCell", for: indexPath) as? ScheduleCollectionViewCell else {
            fatalError("Unable to dequeue ScheduleCollectionViewCell")
            }
        
        let schedule = getToday(meetings: meetings, date: date)[indexPath.item]
        cell.scheNameLabel.text = schedule.name
        
        cell.scheDateLabel.text = schedule.dateString
                
        return cell
    }
}

extension ScheduleListViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMeetingDetail2" {
            if let indexPath = collectionView.indexPathsForSelectedItems?.first {
                let selectedMeeting = getToday(meetings: meetings, date: date)[indexPath.item]
                
                if let destinationVC = segue.destination as? FriendMeetingDetailViewController {
                    destinationVC.selectedMeeting = selectedMeeting
                }
            }
        }
    }
}

class ScheduleCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var scheDateLabel: UILabel!
    @IBOutlet weak var scheNameLabel: UILabel!
}
