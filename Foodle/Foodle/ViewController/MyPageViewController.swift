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
    
    var myPageUser: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myPageUser = user
        
        if let user = myPageUser {
            if let profileImageURL = user.profileImage {
                if let url = URL(string: profileImageURL) {
                    loadImageAsync(from: url) { [weak self] image in
                        DispatchQueue.main.async {
                            self?.profileImg_1.image = image
                            self?.profileImg_2.image = image
                        }
                    }
                }
            }
            nameLabel.text = user.name
            nicknameLabel.text = user.nickName
        }
    }
    
    func loadImageAsync(from url: URL, completion: @escaping (UIImage?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Failed to load image from URL")
                completion(nil)
                return
            }
            completion(UIImage(data: data))
        }
        task.resume()
    }
}
