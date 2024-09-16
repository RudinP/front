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
        
        // 사용자의 preferredTime 데이터가 있다면 가져와서 리스트에 추가
        if let userPreferredTimes = user?.preferredTime {
            preferredTimeList = userPreferredTimes
        } else {
            preferredTimeList = Array(repeating: PreferredTime(day: .월, start: "00:00", end: "00:00"), count: 7)
        }

        if let user = user {
            likeWordText.text = user.likeWord?.joined(separator: "/") ?? ""
            dislikeWordText.text = user.dislikeWord?.joined(separator: "/") ?? ""
        }
        
        tableView.reloadData()
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        let likeWords = likeWordText.text?.split(separator: "/").map { $0.trimmingCharacters(in: .whitespaces) } ?? []
        let dislikeWords = dislikeWordText.text?.split(separator: "/").map { $0.trimmingCharacters(in: .whitespaces) } ?? []

        guard let uid = user?.uid else {
            return
        }

        let updateCompletion: () -> Void = { [weak self] in
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "성공", message: "성공적으로 저장되었습니다.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self?.present(alert, animated: true, completion: nil)
            }
        }

        updateUserLikeWords(uid: uid, likeWords: likeWords) {
            updateUserDislikeWords(uid: uid, dislikeWords: dislikeWords, completion: updateCompletion)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserSettingViewCell", for: indexPath) as! UserSettingViewCell
        let preferredTime = preferredTimeList[indexPath.row]
        
        cell.configureCell(preferredTime: preferredTime, day: Day.allCases[indexPath.row])
        
        return cell
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
