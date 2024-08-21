//
//  MeetingListViewController.swift
//  Foodle
//
//  Created by 루딘 on 8/21/24.
//

import UIKit

class MeetingListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var contents: [Meeting]?
    var selected: Meeting?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contents = meetings
        // Do any additional setup after loading the view.
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
        if let vc = segue.destination as? DetailMeetingViewController{
            vc.selectedMeeting = selected
        }
    }
    
}

extension MeetingListViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contents?.count ?? 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MeetingListTableViewCell", for: indexPath) as! MeetingListTableViewCell
        guard let target =  contents?[indexPath.row] else {return cell}
        cell.dateLabel.text = target.dateString
        cell.nameLabel.text = target.name
        cell.joinersLabel.text = target.joiners?.map({ user in
            user.nickName ?? "정보 없음"
        }).joined(separator: ",")
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selected = contents?[indexPath.row]
        performSegue(withIdentifier: "toDetail", sender: nil)
    }
}

extension MeetingListViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let result = (searchBar.text ?? "" + searchText).lowercased()
        if result.isEmpty{
            contents = meetings
        } else {
            let resultMeetings = meetings?.filter({ meeting in
                let nameCorrect = meeting.name?.lowercased().contains(result)
                let joinerCorrect = meeting.joiners?.map({ user in
                    user.nickName?.lowercased()
                }).contains(where: { name in
                    guard let name else {return false}
                    return name.contains(result)
                })
                let dateCorrect = meeting.dateString?.contains(result)
                let dateCorrect2 = meeting.dateString?.split(separator: "/").joined().contains(result)
                return nameCorrect ?? false || joinerCorrect ?? false || dateCorrect ?? false || dateCorrect2 ?? false
            })
            contents = resultMeetings
        }
        tableView.reloadData()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        contents = meetings
        view.endEditing(true)
        tableView.reloadData()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
}
