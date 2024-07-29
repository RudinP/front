//
//  AddMeetingPlaceViewController.swift
//  Foodle
//
//  Created by 루딘 on 3/21/24.
//

import UIKit

var addMeetingPlaceVC: UIViewController?

class AddMeetingPlaceViewController: UIViewController{
    var newMeeting: Meeting?
    
    @IBOutlet weak var addMeetingPlaceTableView: UITableView!
    
    @IBAction func toSearch(_ sender: Any) {
        performSegue(withIdentifier: "toSearch", sender: nil)
    }
    
    @IBAction func setTime(_ sender: UIDatePicker) {
        newMeeting?.places?[sender.tag].time = sender.date
        newMeeting?.places?.sort(by: { (lhs, rhs)in
            guard let one = lhs.time, let two = rhs.time else {return true}
            return one < two
        })
        presentedViewController?.dismiss(animated: true)
        addMeetingPlaceTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addMeetingPlaceVC = self
        
        if newMeeting?.places == nil{
            newMeeting?.places = [MeetingPlace]()
        }
        
        NotificationCenter.default.addObserver(forName: .meetingPlaceAdded, object: nil, queue: .main) { noti in
            if let place = noti.userInfo?["placeToMeet"] as? Place{
                let meetingPlace = MeetingPlace(place: place, time: self.newMeeting?.places?.last?.time?.addingTimeInterval(3600) ?? self.newMeeting?.date)
                self.newMeeting?.places?.append(meetingPlace)
                DispatchQueue.main.async{
                    self.addMeetingPlaceTableView.reloadData()
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool)
     {
         super.viewWillDisappear(animated)
         self.resignFirstResponder()
         
         if self.isMovingFromParent == true
         {
             guard let newMeeting else {return}
             NotificationCenter.default.post(name: .poppedWhenMeetingAdding, object: nil, userInfo: ["newMeeting": newMeeting])
         }
     }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier != "toSearch"{
            addMeeting(newMeeting){
                NotificationCenter.default.post(name: .meetingAdded, object: nil, userInfo: nil)
            }
        }
        if let places = newMeeting?.places, places.isEmpty {
            let alert = UIAlertController(title: "알림", message: "만날 장소를 정해주세요.", preferredStyle: .alert)
            let ok = UIAlertAction(title: "확인", style: .default)
            alert.addAction(ok)
            
            present(alert, animated: true)
            return false
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSearch"{
            guard let newMeeting else {return}
            if let vc = segue.destination as? SearchResultViewController{
                vc.newMeeting = newMeeting
            }
        }
    }
}

extension AddMeetingPlaceViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return newMeeting?.places?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = addMeetingPlaceTableView.dequeueReusableCell(withIdentifier: "AddMeetingPlaceTableViewCell", for: indexPath) as? AddMeetingPlaceTableViewCell else {return UITableViewCell()}
        
        let target = newMeeting?.places?[indexPath.row]
        cell.placeLabel.text = target?.place?.placeName
        if let time = target?.time{
            cell.timePicker.date = time
            cell.timePicker.minimumDate = newMeeting?.date
            if indexPath.row == 0{
                cell.timePicker.maximumDate = newMeeting?.date
            }
        }
        cell.orderLabel.text = "\(indexPath.row + 1)"
        
        cell.timePicker.tag = indexPath.row
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let alert = UIAlertController(title: "알림", message: "약속에서 해당 장소를 삭제할까요?", preferredStyle: .alert)
            let ok = UIAlertAction(title: "네", style: .default) { _ in
                let target = self.newMeeting?.places?.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.reloadData()
            }
            let no = UIAlertAction(title: "아니오", style: .cancel)
            alert.addAction(no)
            alert.addAction(ok)
            
            present(alert,animated: true)
        }
    }
    
}

extension Notification.Name{
    static let meetingAdded = Notification.Name(rawValue: "meetingAdded")
    static let poppedWhenMeetingAdding = Notification.Name(rawValue: "poppedWhenMeetingAdding")
}
