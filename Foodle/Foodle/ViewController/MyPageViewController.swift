//
//  MyPageViewController.swift
//  Foodle
//
//  Created by 민정 on 5/7/24.
//

import UIKit
import KakaoSDKAuth
import KakaoSDKUser

class MyPageViewController: UIViewController {
    @IBOutlet var profileImg_1: UIImageView!
    @IBOutlet var profileImg_2: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var nicknameLabel: UILabel!
    @IBOutlet var nicknameInput: UITextField!
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var logoutButton: UIButton!
    @IBOutlet var withdrawalButton: UIButton!
    @IBOutlet weak var addFriendsCode: UILabel!
    
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
            
            guard let uid = user.uid else { return }
            
            fetchFriendCode(for: uid)
            withdrawalButton.addTarget(self, action: #selector(withdrawalButtonTapped), for: .touchUpInside)
            logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
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
    
    func fetchFriendCode(for uid: String) {
        var url = url!
        url.append(path: "/api/users/getFriendCode")
        
        guard let uid = user?.uid else {
                return
            }
        
        url.append(queryItems: [URLQueryItem(name: "uid", value: uid)])

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if let error = error {
                print("Failed to fetch friend code: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            if let responseString = String(data: data, encoding: .utf8) {
                //print("Response data as string: \(responseString)")
                DispatchQueue.main.async {
                    self?.addFriendsCode.text = responseString
                }
            } else {
                print("Failed to convert response data to string")
            }
        }
        task.resume()
    }
    
    @objc func withdrawalButtonTapped() {
        var url = url!
        url.append(path: "/api/users/delete")
        
        guard let uid = user?.uid else {
            return
        }
        
        url.append(queryItems: [URLQueryItem(name: "uid", value: uid)])

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Failed to delete user: \(error.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Failed to delete user: Invalid response")
                return
            }
            
            DispatchQueue.main.async {
                // 유저 탈퇴 후 첫 화면으로 전환
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                    let storyboard = UIStoryboard(name: "Minjeong", bundle: nil)
                    if let initialViewController = storyboard.instantiateInitialViewController() {
                        let window = windowScene.windows.first
                        window?.rootViewController = initialViewController
                        window?.makeKeyAndVisible()
                    }
                }
            }
        }
        task.resume()
    }
    
    @objc func logoutButtonTapped() {
        UserApi.shared.logout { (error) in
            /*if let error = error {
                print("Kakao logout failed: \(error.localizedDescription)")
            } else {*/
                print("Kakao logout success.")
                // 로그아웃 후 첫 화면으로 전환
                DispatchQueue.main.async {
                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                        let storyboard = UIStoryboard(name: "Minjeong", bundle: nil)
                        if let initialViewController = storyboard.instantiateInitialViewController() {
                            let window = windowScene.windows.first
                            window?.rootViewController = initialViewController
                            window?.makeKeyAndVisible()
                        }
                    }
                }
            }
        //}
        user = nil
    }
}
