//
//  UserSettingViewController.swift
//  Foodle
//
//  Created by 민정 on 9/16/24.
//

import UIKit

class UserSettingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var likeWordText: UITextField!
    @IBOutlet weak var dislikeWordText: UITextField!
    var preferredTimeList: [PreferredTime] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        preferredTimeList = Day.allCases.map { PreferredTime(day: $0, start: "00:00", end: "00:00") }
        
        if let userPreferredTimes = user?.preferredTime {
            for time in userPreferredTimes {
                if let index = Day.allCases.firstIndex(of: time.day) {
                    preferredTimeList[index] = time
                }
            }
        }
        
        if let user = user {
            likeWordText.text = user.likeWord?.joined(separator: "/") ?? ""
            dislikeWordText.text = user.dislikeWord?.joined(separator: "/") ?? ""
        }
        
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Day.allCases.count // 항상 7개의 셀(요일)로 고정
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserSettingViewCell", for: indexPath) as! UserSettingViewCell
        
        let preferredTime = preferredTimeList[indexPath.row]
        cell.configureCell(preferredTime: preferredTime, day: Day.allCases[indexPath.row])
        
        return cell
    }

    @IBAction func saveButtonTapped(_ sender: UIButton) {
        let likeWords = likeWordText.text?.split(separator: "/").map { $0.trimmingCharacters(in: .whitespaces) } ?? []
        let dislikeWords = dislikeWordText.text?.split(separator: "/").map { $0.trimmingCharacters(in: .whitespaces) } ?? []

        guard let uid = user?.uid else {
            return
        }
        
        var preferredTimes: [PreferredTime] = []
        
        for day in Day.allCases {
            let index = Day.allCases.firstIndex(of: day)!
            if let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? UserSettingViewCell {
                let startTime = cell.startTimePicker.date
                let endTime = cell.endTimePicker.date

                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "HH:mm"
                let startTimeString = dateFormatter.string(from: startTime)
                let endTimeString = dateFormatter.string(from: endTime)
                
                preferredTimes.append(PreferredTime(day: day, start: startTimeString, end: endTimeString))
            }
        }

        //print("\(preferredTimes)")

        let updatedUser = User(
            uid: uid,
            profileImage: user?.profileImage,
            name: user?.name,
            nickName: user?.nickName,
            preferredTime: preferredTimes,
            likeWord: likeWords,
            dislikeWord: dislikeWords
        )
        
        updateUser(user: updatedUser) { [weak self] in
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "성공", message: "성공적으로 저장되었습니다.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self?.present(alert, animated: true, completion: nil)
            }
        }

        updateUserLikeWords(uid: uid, likeWords: likeWords) {
            updateUserDislikeWords(uid: uid, dislikeWords: dislikeWords) {
            }
        }
    }
}

class UserSettingViewCell: UITableViewCell {
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var startTimePicker: UIDatePicker!
    @IBOutlet weak var endTimePicker: UIDatePicker!

    func configureCell(preferredTime: PreferredTime, day: Day) {
        dayLabel.text = day.rawValue
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        if let startTime = dateFormatter.date(from: preferredTime.start) {
            startTimePicker.date = startTime
        }
        
        if let endTime = dateFormatter.date(from: preferredTime.end) {
            endTimePicker.date = endTime
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        startTimePicker.datePickerMode = .time
        endTimePicker.datePickerMode = .time
        
        let locale = Locale(identifier: "en_GB")
        startTimePicker.locale = locale
        endTimePicker.locale = locale
    }
}
