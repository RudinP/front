//
//  SelectFriendsViewController.swift
//  Foodle
//
//  Created by 루딘 on 3/21/24.
//

import UIKit

class SelectFriendsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var selectedName: UICollectionView!
    @IBOutlet var favLabel: UILabel!
    @IBOutlet var favTable: UITableView!
    @IBOutlet var allLabel: UILabel!
    @IBOutlet var allTable: UITableView!
    @IBOutlet var addFriends: UIButton!
    

    var newMeeting: Meeting?//추가할 미팅
    var Friends: [Friend] = friends!

    
    // 모든 친구 데이터 (즐겨찾기 포함)
    var allFriends: [Friend] {
        return Friends
    }
    
    // 즐겨찾기한 친구 데이터
    var favFriends: [Friend] {
        return Friends.filter { $0.like }
    }
    
    var scrollView: UIScrollView!

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSetMeeting"{
            if let vc = segue.destination as? SetMeetingViewController{
                vc.newMeeting = newMeeting
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScrollView()
        
        self.title = "친구 선택"
        let nextButton = UIBarButtonItem(title: "다음", style: .plain, target: self, action: #selector(nextButtonTapped))
        navigationItem.rightBarButtonItem = nextButton
        
        selectedName.dataSource = self
        selectedName.delegate = self
        self.favTable.delegate = self
        self.favTable.dataSource = self
        self.allTable.delegate = self
        self.allTable.dataSource = self
        
        // favTable과 allTable의 스크롤 비활성화
        self.favTable.isScrollEnabled = false
        self.allTable.isScrollEnabled = false
        
        guard let user else {return}
        newMeeting = Meeting()
        newMeeting?.joiners = [User]()
        newMeeting?.joiners?.append(user)//본인은 필수 참여
    }
    
    @objc func nextButtonTapped() {
        performSegue(withIdentifier: "showSetMeeting", sender: self)
    }
    
    func setupScrollView() {
        scrollView = UIScrollView(frame: view.bounds)
        view.addSubview(scrollView)
        
        scrollView.addSubview(searchBar)
        scrollView.addSubview(selectedName)
        scrollView.addSubview(favLabel)
        scrollView.addSubview(favTable)
        scrollView.addSubview(allLabel)
        scrollView.addSubview(allTable)
        scrollView.addSubview(addFriends)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        selectedName.frame.origin.y = searchBar.frame.maxY + 10
        favLabel.frame.origin.y = selectedName.frame.maxY + 10
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
    
    func updateFriendState(for friend: Friend) {
        if isSelected(friend) {
            removeFriend(friend)
        } else {
            addFriend(friend)
        }
        
        selectedName.reloadData()
        favTable.reloadData()
        allTable.reloadData()
    }
    
    func addFriend(_ friend: Friend) {
        newMeeting?.joiners?.append(friend.user)
    }

    func removeFriend(_ friend: Friend) {
        newMeeting?.joiners?.removeAll { $0.uid == friend.user.uid }
    }
    
    func isSelected(_ friend: Friend) -> Bool {
        return newMeeting?.joiners?.contains(where: { $0.uid == friend.user.uid }) ?? false
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return newMeeting?.joiners?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectFriendsNameCell", for: indexPath) as? SelectFriendsNameCollectionViewCell else {
            fatalError("Unable to dequeue SelectFriendsNameCollectionViewCell")
        }
        
        let selectedFriend = newMeeting?.joiners?[indexPath.item]
        cell.selectedName.text = selectedFriend?.nickName
        
        cell.onDeleteButtonTapped = { [weak self] in
            self?.removeFriendByUID(selectedFriend?.uid ?? "")
        }
        
        return cell
    }

    func removeFriendByUID(_ uid: String) {
        if let friend = Friends.first(where: { $0.user.uid == uid }) {
            removeFriend(friend)
        }
        selectedName.reloadData()
        favTable.reloadData()
        allTable.reloadData()
    }
}

extension SelectFriendsViewController: UITableViewDelegate, UITableViewDataSource {
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "SelectFavCell", for: indexPath) as! SelectFavCell
            let friend = favFriends[indexPath.row]
            cell.configure(with: friend, isSelected: isSelected(friend))
            cell.delegate = self
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SelectAllCell", for: indexPath) as! SelectAllCell
            let friend = allFriends[indexPath.row]
            cell.configure(with: friend, isSelected: isSelected(friend))
            cell.delegate = self
            return cell
        }
    }
}

extension SelectFriendsViewController: SelectFavCellDelegate {
    func didTapFavoriteButton(on cell: SelectFavCell) {
        if let indexPath = favTable.indexPath(for: cell) {
            let friend = favFriends[indexPath.row]
            updateFriendState(for: friend)
        }
    }
}

extension SelectFriendsViewController: SelectAllCellDelegate {
    func didTapAllButton(on cell: SelectAllCell) {
        if let indexPath = allTable.indexPath(for: cell) {
            let friend = allFriends[indexPath.row]
            updateFriendState(for: friend)
        }
    }
}

protocol SelectFavCellDelegate: AnyObject {
    func didTapFavoriteButton(on cell: SelectFavCell)
}

protocol SelectAllCellDelegate: AnyObject {
    func didTapAllButton(on cell: SelectAllCell)
}

class SelectFavCell: UITableViewCell {
    @IBOutlet var favImg: UIImageView!
    @IBOutlet var favName: UILabel!
    @IBOutlet var favButton: UIButton!
    
    weak var delegate: SelectFavCellDelegate?
    private var friend: Friend?
    
    func configure(with friend: Friend, isSelected: Bool) {
        self.friend = friend
        favName.text = friend.user.nickName
        
        if let str = friend.user.profileImage {
            favImg.setImageFromStringURL(str)
        }
        
        favButton.isSelected = isSelected
        updateButtonImage()
    }
    
    func updateButtonImage() {
        if favButton.isSelected {
            favButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        } else {
            favButton.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
        }
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        delegate?.didTapFavoriteButton(on: self)
    }
}

class SelectAllCell: UITableViewCell {
    @IBOutlet var allImg: UIImageView!
    @IBOutlet var allName: UILabel!
    @IBOutlet var allButton: UIButton!
    
    weak var delegate: SelectAllCellDelegate?
    private var friend: Friend?
    
    func configure(with friend: Friend, isSelected: Bool) {
        self.friend = friend
        allName.text = friend.user.nickName
        
        if let url = friend.user.profileImage {
            allImg.setImageFromStringURL(url)
        }
        
        allButton.isSelected = isSelected
        updateButtonImage()
    }
    
    func updateButtonImage() {
        if allButton.isSelected {
            allButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        } else {
            allButton.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
        }
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        delegate?.didTapAllButton(on: self)
    }
}

class SelectFriendsNameCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var selectedName: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    var onDeleteButtonTapped: (() -> Void)?
    
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        onDeleteButtonTapped?()
    }
}
