//
//  MyPageViewController.swift
//  Foodle
//
//  Created by 민정 on 5/7/24.
//

import UIKit

class MyPageViewController: UIViewController {
    @IBOutlet var profileImg_1: UIImageView!
    @IBOutlet var profileImg_2: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var nicknameLabel: UILabel!
    @IBOutlet var nicknameInput: UITextField!
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var logoutButton: UIButton!
    @IBOutlet var withdrawalButton: UIButton!
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        user = dummyUser2
        
        if let user = user {
            if let profileImageURL = user.profileImage {
                if let url = URL(string: profileImageURL), let data = try? Data(contentsOf: url) {
                    profileImg_1.image = UIImage(data: data)
                    profileImg_2.image = UIImage(data: data)
                }
            }
            nameLabel.text = user.name
            nicknameLabel.text = user.nickName
        }
    }
}
