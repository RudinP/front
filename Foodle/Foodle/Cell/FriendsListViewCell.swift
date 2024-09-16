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
    @IBOutlet weak var friendCode: UITextField!
    @IBOutlet weak var addLabel: UILabel!
    
    var activityIndicator: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        return spinner
    }()

    var Friends: [Friend]?
    
    // 모든 친구 데이터 (즐겨찾기 포함)
    var allFriends: [Friend] {
        return Friends ?? []
    }
    
    // 즐겨찾기한 친구 데이터
    var favFriends: [Friend] {
        return Friends?.filter { $0.like } ?? []
    }
    
    var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Friends = friends
        
        setupScrollView()
        
        self.favTable.delegate = self
        self.favTable.dataSource = self
        self.allTable.delegate = self
        self.allTable.dataSource = self
        
        // favTable과 allTable의 스크롤 비활성화
        self.favTable.isScrollEnabled = false
        self.allTable.isScrollEnabled = false
        
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
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
        scrollView.addSubview(friendCode)
        scrollView.addSubview(addLabel)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        favLabel.frame.origin.y = searchBar.frame.maxY + 10
        favTable.frame.origin.y = favLabel.frame.maxY + 10
        favTable.frame.size.height = CGFloat(favFriends.count) * 75 // favTable의 높이를 개수에 맞게 설정
        
        allLabel.frame.origin.y = favTable.frame.maxY + 30
        allTable.frame.origin.y = allLabel.frame.maxY + 10
        allTable.frame.size.height = CGFloat(allFriends.count) * 75 // allTable의 높이를 개수에 맞게 설정
        
        addLabel.frame.origin.y = allTable.frame.maxY + 30
        
        addFriends.frame.origin.y =  addLabel.frame.maxY + 10
        friendCode.frame.origin.y =  addLabel.frame.maxY + 10
                
        // 스크롤 뷰의 contentSize 조정
        let contentHeight = addFriends.frame.origin.y + addFriends.frame.size.height + 90
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: contentHeight)
    }
    
    @IBAction func addFriendsButtonTapped(_ sender: UIButton) {
        var url = url!
        url.append(path: "/api/friends/CreateByCode")
        
        guard let uid = user?.uid else {
            return
        }

        guard let code = friendCode.text, !code.isEmpty else {
            print("Friend code is empty")
            return
        }
        
        url.append(queryItems: [URLQueryItem(name: "uid", value: uid)])
        url.append(queryItems: [URLQueryItem(name: "code", value: code)])
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }

        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
            }

            if let error = error {
                print("Failed to add friend: \(error.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Failed to add friend: Invalid response")
                return
            }
            
            DispatchQueue.main.async {
                self?.reloadTables()
            }
        }
        task.resume()
    }
    
    func reloadTables() {
        favTable.reloadData()
        allTable.reloadData()
        viewDidLayoutSubviews()
        
        fetchFriends(user!.uid!) { friend in
            friends = friend
            DispatchQueue.main.async{
                self.favTable.reloadData()
                self.allTable.reloadData()
            }
        }
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
            cell.configure(with: friend)
            cell.delegate = self
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AllCell", for: indexPath) as! AllCell
            let friend = allFriends[indexPath.row]
            cell.configure(with: friend)
            cell.delegate = self
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
                destinationVC.friendsNameText = selectedFriend.user.nickName
                destinationVC.profileImgUrl = selectedFriend.user.profileImage
                destinationVC.friendUid = selectedFriend.user.uid
                destinationVC.friendLikeWord = selectedFriend.user.likeWord
                destinationVC.friendDislikeWord = selectedFriend.user.dislikeWord
                destinationVC.friendTime = selectedFriend.user.preferredTime
            }
        }
    }
}

extension FriendsListViewCell: FavCellDelegate {
    func didTapFavoriteButton(on cell: FavCell) {
        guard let indexPath = favTable.indexPath(for: cell),
              var friends = Friends else {
            return
        }
        
        let friend = favFriends[indexPath.row]
        if let index = friends.firstIndex(where: { $0.user.uid == friend.user.uid }) {
            friends[index].like.toggle()
            updateFriendFavorite(friends[index]) {
                self.Friends = friends
                DispatchQueue.main.async {
                    self.reloadTables()
                }
            }
        }
    }
}

extension FriendsListViewCell: AllCellDelegate {
    func didTapFavoriteButton(on cell: AllCell) {
        guard let indexPath = allTable.indexPath(for: cell),
              var friends = Friends else {
            return
        }
        
        let friend = allFriends[indexPath.row]
        if let index = friends.firstIndex(where: { $0.user.uid == friend.user.uid }) {
            friends[index].like.toggle()
            updateFriendFavorite(friends[index]) {
                self.Friends = friends
                DispatchQueue.main.async {
                    self.reloadTables()
                }
            }
        }
    }
}

protocol FavCellDelegate: AnyObject {
    func didTapFavoriteButton(on cell: FavCell)
}

protocol AllCellDelegate: AnyObject {
    func didTapFavoriteButton(on cell: AllCell)
}

class FavCell: UITableViewCell {
    @IBOutlet var favImg: UIImageView!
    @IBOutlet var favName: UILabel!
    @IBOutlet var favButton: UIButton!
    
    weak var delegate: FavCellDelegate?
    private var friend: Friend?
    
    func configure(with friend: Friend) {
        self.friend = friend
        favName.text = friend.user.nickName
        
        if let str = friend.user.profileImage {
            favImg.setImageFromStringURL(str)
        }
        
        favButton.isSelected = friend.like
        updateButtonImage()
    }
    
    private func updateButtonImage() {
        if favButton.isSelected {
            favButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        } else {
            favButton.setImage(UIImage(systemName: "star"), for: .normal)
        }
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        delegate?.didTapFavoriteButton(on: self)
    }
}

class AllCell: UITableViewCell {
    @IBOutlet var allImg: UIImageView!
    @IBOutlet var allName: UILabel!
    @IBOutlet var allButton: UIButton!
    
    weak var delegate: AllCellDelegate?
    private var friend: Friend?
    
    func configure(with friend: Friend) {
        self.friend = friend
        allName.text = friend.user.nickName
        
        if let url = friend.user.profileImage {
            allImg.setImageFromStringURL(url)
        }
        
        allButton.isSelected = friend.like
        updateButtonImage()
    }
    
    private func updateButtonImage() {
        if allButton.isSelected {
            allButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        } else {
            allButton.setImage(UIImage(systemName: "star"), for: .normal)
        }
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        delegate?.didTapFavoriteButton(on: self)
    }
}
