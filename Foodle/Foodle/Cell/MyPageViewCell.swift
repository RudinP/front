//
//  MyPageViewCell.swift
//  Foodle
//
//  Created by 민정 on 5/7/24.
//

import UIKit

class MyPageViewCell: UIViewController {
    @IBOutlet var profileImg_1: UIImageView!
    @IBOutlet var profileImg_2: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var nicknameLabel: UILabel!
    @IBOutlet var cautionLabel: UILabel!
    @IBOutlet var nicknameInput: UITextField!
    @IBOutlet var photoLabel: UILabel!
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var logoutLabel: UILabel!
    @IBOutlet var withdrawalLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImg_1.image = UIImage(named: "icon_profile.png")
        profileImg_2.image = UIImage(named: "icon_profile.png")
        profileImg_1.layer.cornerRadius = profileImg_1.frame.size.width / 2
        profileImg_2.layer.cornerRadius = profileImg_1.frame.size.width / 4
        
        saveButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 28.0)
        
        withdrawalLabel.attributedText =  NSAttributedString(string: "회원탈퇴", attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue])
    }
}
