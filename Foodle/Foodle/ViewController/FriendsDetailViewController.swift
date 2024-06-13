//
//  FriendsDetailViewController.swift
//  Foodle
//
//  Created by 민정 on 6/10/24.
//

import UIKit

class FriendsDetailViewController: UIViewController {
    @IBOutlet var friendsNameLabel: UILabel!
    @IBOutlet weak var profileImg: UIImageView!
    
    var friendsNameText: String?
    var profileImgName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let friendsNameText = friendsNameText {
            friendsNameLabel.text = friendsNameText
        }
        
        if let profileImgName = profileImgName {
            profileImg.image = UIImage(named: profileImgName)
        }
    }
}
