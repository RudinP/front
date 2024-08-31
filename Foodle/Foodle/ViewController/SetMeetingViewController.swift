//
//  SetMeetingViewController.swift
//  Foodle
//
//  Created by 루딘 on 3/21/24.
//

import UIKit

class SetMeetingViewController: UIViewController {
    var newMeeting: Meeting?
    var editableMeeting: EditableMeeting?
    var recommendedTime = [Date]()
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var meetingNameTextField: UITextField!
    @IBOutlet weak var meetingDateLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBAction func setDate(_ sender: UIDatePicker) {
        recommendedTime = recommendTime()
        newMeeting?.date = sender.date
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "YYYY.MM.dd (E) a h:mm"
        meetingDateLabel.text = formatter.string(from: sender.date)
        tableView.reloadData()
        collectionView.reloadData()
    }
    
    func checkDup() -> Bool{
        for meeting in getToday(meetings: meetings, date: datePicker.date){
            if meeting.mid != newMeeting?.mid{
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
        
        if editableMeeting != nil {
            newMeeting = editableMeeting?.origin
        }
        
        tableView.dataSource = self
        tableView.delegate = self
        meetingNameTextField.delegate = self
        
        loadDataIfNeeded()
        setDate(datePicker)
        datePicker.minimumDate = Date.now
        
        recommendedTime = recommendTime()
        
        NotificationCenter.default.addObserver(forName: .poppedWhenMeetingAdding, object: nil, queue: .main) { noti in
            if let data = noti.userInfo?["newMeeting"] as? Meeting{
                self.newMeeting = data
            }
            
        }
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        self.resignFirstResponder()
        
        if self.isMovingFromParent == true
        {
            if let name = meetingNameTextField.text{
                newMeeting?.name = name
            }
            newMeeting?.date = datePicker.date
            guard let newMeeting else {return}
            NotificationCenter.default.post(name: .poppedWhenMeetingAdding, object: nil, userInfo: ["newMeeting": newMeeting])
        }
        
    }
    
    func hideKeyboard() {
            let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                                     action: #selector(dismissKeyboard))
            view.addGestureRecognizer(tap)
            
            // 또는 아래처럼 작성하셔도 됩니다.
            
           // view.addGestureRecognizer(UITapGestureRecognizer(target: self,
           //                                                  action: #selector(dismissKeyboard)))
        }
        
       @objc func dismissKeyboard() {
           view.endEditing(true)
       }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAddMeetingPlace"{
            if let vc = segue.destination as? AddMeetingPlaceViewController{
                editableMeeting?.origin = newMeeting
                vc.newMeeting = newMeeting
                vc.editableMeeting = editableMeeting
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
    
    func recommendTime() -> [Date]{
        var result = [Date]()
        var stringResult = [[String]]()
        
        let day = datePicker.date
        let calendar = Calendar.current
        let component = calendar.dateComponents([.day], from: day)
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "E"
        
        var selectedDay: Day?
        if let dayString = calendar.date(from: component){
            let str = dateFormatter.string(from: dayString)
            selectedDay = Day(rawValue: str)
        }
        
        let pTimes = newMeeting?.joiners?.map({ user in
            user.preferredTime?.filter({ pTime in
                pTime.day == selectedDay
            })
        })
        
        let times:[PreferredTime] = pTimes?.flatMap{$0!} ?? []
        guard times.count > 0 else {return result}
        
        var start = times.map { $0.start }.max()!
        let end = times.map { $0.end }.min()!
        
        if start < end {
            result.append(start)
            while let t = start.nextHour(), t < end{
                result.append(t)
            }
        }
        
        return result
    }

    @IBAction func selectRecommend(_ sender: UIButton) {
        datePicker.date.setTime(recommendedTime[sender.tag])
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

extension SetMeetingViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recommendedTime.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecommendedTimeCollectionViewCell", for: indexPath) as! RecommendedTimeCollectionViewCell
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "a h:mm"
        cell.timeButton.setTitle(formatter.string(from: recommendedTime[indexPath.item]), for: .normal)
        cell.timeButton.setTitle(formatter.string(from: recommendedTime[indexPath.item]), for: .selected)
        cell.tag = indexPath.item
        
        return cell
    }
    
    
}
