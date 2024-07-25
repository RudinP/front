//
//  AddMeetingPlaceViewController.swift
//  Foodle
//
//  Created by 루딘 on 3/21/24.
//

import UIKit

class AddMeetingPlaceViewController: UIViewController{
    var newMeeting: Meeting?
    
    @IBOutlet weak var addMeetingPlaceTableView: UITableView!
    
    @IBAction func toSearch(_ sender: Any) {
        performSegue(withIdentifier: "toSearch", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if newMeeting?.places == nil{
            newMeeting?.places = [MeetingPlace]()
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier != "toSearch"{
            addMeeting(newMeeting){
                NotificationCenter.default.post(name: .meetingAdded, object: nil, userInfo: nil)
            }
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSearch"{
            guard let newMeeting else {return}
            NotificationCenter.default.post(name: .searchPlaceToMeet, object: nil, userInfo: ["newMeeting":newMeeting])
        } else {
            
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
        cell.timeLabel.text = target?.timeString
        cell.orderLabel.text = "\(indexPath.row + 1)"
        
        return cell
    }
    
}

extension Notification.Name{
    static let meetingAdded = Notification.Name(rawValue: "meetingAdded")
    static let searchPlaceToMeet = Notification.Name(rawValue: "searchPlaceToMeet")
}
