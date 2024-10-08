//
//  LoginViewCell.swift
//  Foodle
//
//  Created by 민정 on 3/19/24.
//

import UIKit
import KakaoSDKAuth
import KakaoSDKUser
import KakaoSDKCommon

class LoginViewController: UIViewController {
    @IBOutlet var loginLabel: UILabel!
    @IBOutlet var loginLabel2: UILabel!
    @IBOutlet var kakaoButton: UIButton!
    @IBOutlet var naverButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // '프들'만 볼드체로 변경
        if let labelText = loginLabel.text {
            let attributedString = NSMutableAttributedString(string: labelText)
            attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: loginLabel.font.pointSize), range: NSRange(location: 0, length: 2)) // 첫 번째 글자와 두 번째 글자에 적용
            loginLabel.attributedText = attributedString
        }
        
        kakaoButton.addTarget(self, action: #selector(handleKakaoLogin), for: .touchUpInside)

        NotificationCenter.default.addObserver(forName: .loginCompleted, object: nil, queue: .main) { _ in
            self.toLaunch()
        }
    }

    // 카카오톡 로그인 버튼을 눌렀을 때 실행되는 메서드
    @objc func handleKakaoLogin() {
        // 카카오톡 실행 가능 여부 확인
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.loginWithKakaoTalk { (oauthToken, error) in
                if let error = error {
                    print(error)
                } else {
                    print("loginWithKakaoTalk() success.")
                    // 사용자 정보 가져오기
                    self.kakaoGetUserInfo()
                }
            }
        } else {
            // 카카오톡이 설치되지 않았을 경우 웹 로그인을 진행할 수 있도록 처리
            UserApi.shared.loginWithKakaoAccount { (oauthToken, error) in
                if let error = error {
                    print(error)
                } else {
                    print("loginWithKakaoAccount() success.")
                    // 사용자 정보 가져오기
                    self.kakaoGetUserInfo()
                }
            }
        }
    }
    
    private func toLaunch(){
        let storyboard = UIStoryboard(name: "Jinhee", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LaunchVC")
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }

    @IBAction func naverLogin(_ sender: Any) {
        NaverSNSLogin.shared.login(){
            UserDefaultsManager.userData = user
        }
    }
    
    // 사용자 정보 가져오기
    private func kakaoGetUserInfo() {
        UserApi.shared.me { (kakaoUser, error) in
            if let error = error {
                print(error)
                return
            }
            guard let kakaoUser = kakaoUser else { return }

            guard let id = kakaoUser.id else { return }

            let uid = String(id)
            let profileImage = kakaoUser.kakaoAccount?.profile?.profileImageUrl?.absoluteString ?? ""
            let nickname = kakaoUser.kakaoAccount?.profile?.nickname ?? ""

            let newUser = User(uid: uid, profileImage: profileImage, name: nickname, nickName: nickname)
            
            fetchUser(uid) { result in
                let group = DispatchGroup()
                
                group.enter()
                if let result = result {
                    user = result
                    //print("Existing user: \(result)")
                    group.leave()
                } else {
                    group.enter()
                    createUser(newUser) {
                        fetchUser(uid) { result in
                            user = result
                            //print("Created new user: \(String(describing: result))")
                        }
                        group.leave()
                    }
                }
                group.notify(queue: .main) {
                    UserDefaultsManager.userData = user
                    NotificationCenter.default.post(name: .loginCompleted, object: nil, userInfo: nil)
                }
            }
        }
    }
  
    // 로그아웃 버튼을 눌렀을 때 실행되는 메서드
    @objc private func handleKakaoLogout() {
        UserApi.shared.logout { (error) in
            if let error = error {
                print(error)
            } else {
                UserDefaultsManager.userData = nil
                print("logout() success.")
            }
        }
    }
}

extension Notification.Name{
    static let loginCompleted = Notification.Name("loginCompleted")
}
