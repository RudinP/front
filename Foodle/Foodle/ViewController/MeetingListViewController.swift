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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        contents = meetings
        // Do any additional setup after loading the view.
    }

}

extension MeetingListViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contents?.count ?? 0
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
}

extension MeetingListViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let result = searchBar.text ?? "" + searchText
        if result.isEmpty{
            contents = meetings
        } else {
            let resultMeetings = meetings?.filter({ meeting in
                let nameCorrect = meeting.name?.contains(result)
                let joinerCorrect = meeting.joiners?.map({ user in
                    user.nickName
                }).contains(where: { name in
                    guard let name else {return false}
                    return name.contains(result)
                })
                return nameCorrect ?? false || joinerCorrect ?? false
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
