//
//  SetMeetingViewController.swift
//  Foodle
//
//  Created by 루딘 on 3/21/24.
//

import UIKit

class SetMeetingViewController: UIViewController {
    var newMeeting: Meeting?
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var meetingNameTextField: UITextField!
    @IBOutlet weak var meetingDateLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func setDate(_ sender: UIDatePicker) {
        newMeeting?.date = sender.date
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "YYYY.MM.dd (E) a h:mm"
        meetingDateLabel.text = formatter.string(from: sender.date)
        tableView.reloadData()
    }
    
    func checkDup() -> Bool{
        for meeting in getToday(meetings: meetings, date: datePicker.date){
            if let date = meeting.date{
                if date.formatted() == datePicker.date.formatted(){
                    return true
                }
                if let last = meeting.places?.last, let lastDate = last.time {
                    if date < datePicker.date && lastDate > datePicker.date{
                        return true
                    }
                }
            }
        }
        return false
    }
    
    func loadDataIfNeeded(){
        if let date = newMeeting?.date{
            datePicker.date = date
        }
        if let name = newMeeting?.name{
            meetingNameTextField.text = name
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        meetingNameTextField.delegate = self
        
        
        
        loadDataIfNeeded()
        setDate(datePicker)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAddMeetingPlace"{
            if let vc = segue.destination as? AddMeetingPlaceViewController{
                vc.newMeeting = newMeeting
            }
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        super.shouldPerformSegue(withIdentifier: identifier, sender: sender)
        if identifier != "toAddMeetingPlace" {
            return true
        }
        newMeeting?.name = meetingNameTextField.text
        
        if let name = newMeeting?.name, !name.isEmpty{
            if checkDup() {
                //시간이 겹친다면
                let alert = UIAlertController(title: "알림", message: "다른 약속과 시간이 겹칩니다.", preferredStyle: .alert)
                let ok = UIAlertAction(title: "확인", style: .default)
                alert.addAction(ok)
                
                present(alert, animated: true)
                return false
            }
            
            return true
        } else {
            let alert = UIAlertController(title: "알림", message: "약속의 이름을 입력해주세요.", preferredStyle: .alert)
            let ok = UIAlertAction(title: "확인", style: .default)
            
            alert.addAction(ok)
            
            present(alert, animated: true)
            return false
        }
    }
    
}

extension SetMeetingViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getToday(meetings: meetings, date: datePicker.date).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SetMeetingTableViewCell", for: indexPath) as! SetMeetingTableViewCell
        let meetingsToday = getToday(meetings: meetings, date: datePicker.date)
        let target = meetingsToday[indexPath.row]
        cell.meetingNameLabel.text = target.name
        cell.meetingTimeLabel.text = target.timeString
        
        return cell
    }
}

extension SetMeetingViewController: UITextFieldDelegate{
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField == meetingNameTextField{
            let cnt = meetingNameTextField.text?.count ?? 0
            let isValid = (1 ... 30).contains(cnt)
            textField.layer.borderWidth = isValid ? 0 : 1
            textField.layer.borderColor = isValid ? nil : UIColor.red.cgColor
            textField.layer.cornerRadius = isValid ? 0 : 5
            textField.tintColor = isValid ? view.tintColor : .red
            return isValid
        }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
