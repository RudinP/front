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
    
    let friendsImg = ["icon_apple.png", "icon_kakao.png", "icon_naver.png", "icon_apple.png", "icon_kakao.png", "icon_naver.png"]
    let friendsName = ["김지현", "박진희", "정민정", "김지현", "박진희", "정민정"]
    
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
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        favLabel.frame.origin.y = searchBar.frame.maxY + 10
        favTable.frame.origin.y = favLabel.frame.maxY + 10
        favTable.frame.size.height = CGFloat(friendsName.count) * 75 // favTable의 높이를 개수에 맞게 설정
        
        allLabel.frame.origin.y = favTable.frame.maxY + 30
        allTable.frame.origin.y = allLabel.frame.maxY + 10
        allTable.frame.size.height = CGFloat(friendsName.count) * 75 // allTable의 높이를 개수에 맞게 설정
                
        // 스크롤 뷰의 contentSize 조정
        let contentHeight = allTable.frame.origin.y + allTable.frame.size.height + 30
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: contentHeight)
    }
}

extension FriendsListViewCell: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == favTable {
            return friendsName.count
        } else {
            return friendsName.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 75 // 셀의 높이를 75픽셀로 설정
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == favTable {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FavCell", for: indexPath) as! FavCell
            cell.favImg.image = UIImage(named: friendsImg[indexPath.row])
            cell.favName.text = friendsName[indexPath.row]
            cell.favImg.layer.cornerRadius = 30
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AllCell", for: indexPath) as! AllCell
            cell.allImg.image = UIImage(named: friendsImg[indexPath.row])
            cell.allName.text = friendsName[indexPath.row]
            cell.allImg.layer.cornerRadius = 30
            return cell
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
        let emptyStarImage = UIImage(systemName: "star")
        let filledStarImage = UIImage(systemName: "star.fill")
        
        if isStarred {
            favButton.setImage(filledStarImage, for: .normal)
        } else {
            favButton.setImage(emptyStarImage, for: .normal)
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
        let emptyStarImage = UIImage(systemName: "star")
        let filledStarImage = UIImage(systemName: "star.fill")
        
        if isStarred {
            allButton.setImage(filledStarImage, for: .normal)
        } else {
            allButton.setImage(emptyStarImage, for: .normal)
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
