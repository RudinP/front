//
//  MyPageViewController.swift
//  Foodle
//
//  Created by 민정 on 5/7/24.
//

import UIKit
import KakaoSDKAuth
import KakaoSDKUser

class MyPageViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var profileImg_1: UIImageView!
    @IBOutlet var profileImg_2: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var nicknameLabel: UILabel!
    @IBOutlet var nicknameInput: UITextField!
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var logoutButton: UIButton!
    @IBOutlet var withdrawalButton: UIButton!
    @IBOutlet weak var addFriendsCode: UILabel!
    @IBOutlet weak var timeKeywordButton: UIButton!
    @IBOutlet weak var copyButton: UIButton!
    
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
        
        let SecondAccent: UIColor = UIColor(red: 0.817, green: 0.807, blue: 0.914, alpha: 1.0)
        timeKeywordButton.layer.borderWidth = 1
        timeKeywordButton.layer.borderColor = SecondAccent.cgColor
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func copyButtonTapped(_ sender: UIButton) {
        if let codeText = addFriendsCode.text {
            UIPasteboard.general.string = codeText
            let alert = UIAlertController(title: "", message: "친구 추가 코드가 클립보드에 복사되었습니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "오류", message: "복사할 친구 코드가 없습니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

    @IBAction func saveButtonTapped(_ sender: UIButton) {
        guard let uid = user?.uid else {
            return
        }

        guard let newNickname = nicknameInput.text, !newNickname.isEmpty else {
            return
        }

        let updatedUser = User(
            uid: uid,
            profileImage: user?.profileImage,
            name: user?.name,
            nickName: newNickname,
            preferredTime: user?.preferredTime,
            likeWord: user?.likeWord,
            dislikeWord: user?.dislikeWord
        )

        updateUser(user: updatedUser) { [weak self] in
            DispatchQueue.main.async {
                self?.nicknameLabel.text = newNickname
                
                let alert = UIAlertController(title: "", message: "성공적으로 저장되었습니다.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self?.present(alert, animated: true, completion: nil)
            }
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
