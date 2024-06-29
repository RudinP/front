//
//  FriendsListViewCell.swift
//  Foodle
//
//  Created by 민정 on 3/21/24.
//

import UIKit

class FriendsListViewCell: UIViewController {
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var favLabel: UILabel!
    @IBOutlet var favTable: UITableView!
    @IBOutlet var allLabel: UILabel!
    @IBOutlet var allTable: UITableView!
    @IBOutlet var addFriends: UIButton!
    
    let friends: [Friend] = dummyFriends
    
    // 모든 친구 데이터 (즐겨찾기 포함)
    var allFriends: [Friend] {
        return friends
    }
    
    // 즐겨찾기한 친구 데이터
    var favFriends: [Friend] {
        return friends.filter { $0.like }
    }
    
    var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScrollView()
        
        self.favTable.delegate = self
        self.favTable.dataSource = self
        self.allTable.delegate = self
        self.allTable.dataSource = self
        
        // favTable과 allTable의 스크롤 비활성화
        self.favTable.isScrollEnabled = false
        self.allTable.isScrollEnabled = false
    }
    
    func setupScrollView() {
        scrollView = UIScrollView(frame: view.bounds)
        view.addSubview(scrollView)
        
        scrollView.addSubview(searchBar)
        scrollView.addSubview(favLabel)
        scrollView.addSubview(favTable)
        scrollView.addSubview(allLabel)
        scrollView.addSubview(allTable)
        scrollView.addSubview(addFriends)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        favLabel.frame.origin.y = searchBar.frame.maxY + 10
        favTable.frame.origin.y = favLabel.frame.maxY + 10
        favTable.frame.size.height = CGFloat(favFriends.count) * 75 // favTable의 높이를 개수에 맞게 설정
        
        allLabel.frame.origin.y = favTable.frame.maxY + 30
        allTable.frame.origin.y = allLabel.frame.maxY + 10
        allTable.frame.size.height = CGFloat(allFriends.count) * 75 // allTable의 높이를 개수에 맞게 설정
        
        addFriends.frame.origin.y = allTable.frame.maxY + 10
                
        // 스크롤 뷰의 contentSize 조정
        let contentHeight = allTable.frame.origin.y + allTable.frame.size.height + 90
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: contentHeight)
    }
}

extension FriendsListViewCell: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == favTable {
            return favFriends.count
        } else {
            return allFriends.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75 // 셀의 높이를 75픽셀로 설정
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == favTable {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FavCell", for: indexPath) as! FavCell
            let friend = favFriends[indexPath.row]
            
            if let url = URL(string: friend.profileImage ?? ""), let data = try? Data(contentsOf: url) {
                cell.favImg.image = UIImage(data: data)
            }
            
            cell.favName.text = friend.nickName
            cell.favButton.isSelected = friend.like
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AllCell", for: indexPath) as! AllCell
            let friend = allFriends[indexPath.row]
            
            if let url = URL(string: friend.profileImage ?? ""), let data = try? Data(contentsOf: url) {
                cell.allImg.image = UIImage(data: data)
            }
            
            cell.allName.text = friend.nickName
            cell.allButton.isSelected = friend.like
                
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedFriend: Friend
        
        if tableView == favTable {
            selectedFriend = favFriends[indexPath.row]
        } else {
            selectedFriend = allFriends[indexPath.row]
        }
        
        performSegue(withIdentifier: "showDetail", sender: selectedFriend)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let destinationVC = segue.destination as? FriendsDetailViewController,
               let selectedFriend = sender as? Friend {
                destinationVC.friendsNameText = selectedFriend.nickName
                destinationVC.profileImgUrl = selectedFriend.profileImage
            }
        }
    }
}

class FavCell: UITableViewCell {
    @IBOutlet var favImg: UIImageView!
    @IBOutlet var favName: UILabel!
    @IBOutlet var favButton: UIButton!
    
    var isStarred = true
       
    override func awakeFromNib() {
        super.awakeFromNib()
        setupButton()
    }
    
    func setupButton() {
        if isStarred {
            favButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        } else {
            favButton.setImage(UIImage(systemName: "star"), for: .normal)
        }
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        isStarred.toggle()
        
        // 버튼 상태에 따라 이미지 변경
        if isStarred {
            sender.setImage(UIImage(systemName: "star.fill"), for: .normal)
        } else {
            sender.setImage(UIImage(systemName: "star"), for: .normal)
        }
    }
}

class AllCell: UITableViewCell {
    @IBOutlet var allImg: UIImageView!
    @IBOutlet var allName: UILabel!
    @IBOutlet var allButton: UIButton!
    
    var isStarred = false
                
    override func awakeFromNib() {
        super.awakeFromNib()
        setupButton()
    }
    
    func setupButton() {
        if isStarred {
            allButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        } else {
            allButton.setImage(UIImage(systemName: "star"), for: .normal)
        }
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        isStarred.toggle()
        
        // 버튼 상태에 따라 이미지 변경
        if isStarred {
            sender.setImage(UIImage(systemName: "star.fill"), for: .normal)
        } else {
            sender.setImage(UIImage(systemName: "star"), for: .normal)
        }
    }
}
