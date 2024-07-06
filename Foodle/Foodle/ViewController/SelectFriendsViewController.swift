//
//  SelectFriendsViewController.swift
//  Foodle
//
//  Created by 루딘 on 3/21/24.
//

import UIKit

class SelectFriendsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "친구 선택"
        
        let nextButton = UIBarButtonItem(title: "다음", style: .plain, target: self, action: #selector(nextButtonTapped))
        navigationItem.rightBarButtonItem = nextButton
    }

    @objc func nextButtonTapped() {
        performSegue(withIdentifier: "showSetMeeting", sender: self)
    }
}
