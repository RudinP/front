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

class LoginViewCell: UIViewController {
    @IBOutlet var loginLabel: UILabel!
    @IBOutlet var loginLabel2: UILabel!
    @IBOutlet var kakaoButton: UIButton!
    @IBOutlet var naverButton: UIButton!
    @IBOutlet var appleButton: UIButton!
    @IBOutlet var privacyLabel: UILabel!
    @IBOutlet weak var logoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // PrivacyLabel에 밑줄 추가
        let attributedString = NSMutableAttributedString(string: "개인정보 이용 처리 방침")
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: attributedString.length))
        privacyLabel.attributedText = attributedString
        
        // '프들'만 볼드체로 변경
        if let labelText = loginLabel.text {
            let attributedString = NSMutableAttributedString(string: labelText)
            attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: loginLabel.font.pointSize), range: NSRange(location: 0, length: 2)) // 첫 번째 글자와 두 번째 글자에 적용
            loginLabel.attributedText = attributedString
        }
        
        // 카카오 버튼 액션 연결
        kakaoButton.addTarget(self, action: #selector(handleKakaoLogin), for: .touchUpInside)

        // 로그아웃 버튼 액션 연결
        logoutButton.addTarget(self, action: #selector(handleKakaoLogout), for: .touchUpInside)
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

    // 사용자 정보 가져오기
    private func kakaoGetUserInfo() {
        UserApi.shared.me { (user, error) in
            if let error = error {
                print(error)
            } else {
                guard let user = user else { return }

                var scopes = [String]()
                if (user.kakaoAccount?.profileNeedsAgreement == true) { scopes.append("profile") }
                if (user.kakaoAccount?.emailNeedsAgreement == true) { scopes.append("account_email") }
                if (user.kakaoAccount?.birthdayNeedsAgreement == true) { scopes.append("birthday") }
                if (user.kakaoAccount?.birthyearNeedsAgreement == true) { scopes.append("birthyear") }
                if (user.kakaoAccount?.genderNeedsAgreement == true) { scopes.append("gender") }
                if (user.kakaoAccount?.phoneNumberNeedsAgreement == true) { scopes.append("phone_number") }
                if (user.kakaoAccount?.ageRangeNeedsAgreement == true) { scopes.append("age_range") }
                if (user.kakaoAccount?.ciNeedsAgreement == true) { scopes.append("account_ci") }

                if scopes.count > 0 {
                    print("사용자에게 추가 동의를 받아야 합니다.")
                    UserApi.shared.loginWithKakaoAccount(scopes: scopes) { (_, error) in
                        if let error = error {
                            print(error)
                        } else {
                            UserApi.shared.me { (user, error) in
                                if let error = error {
                                    print(error)
                                } else {
                                    print("me() success.")
                                    guard let user = user else { return }

                                    let userName = user.kakaoAccount?.profile?.nickname
                                    let userEmail = user.kakaoAccount?.email
                                    let userGender = user.kakaoAccount?.gender
                                    let userProfile = user.kakaoAccount?.profile?.profileImageUrl
                                    let userBirthYear = user.kakaoAccount?.birthyear

                                    let contentText = """
                                    user name: \(userName ?? "N/A")
                                    userEmail: \(userEmail ?? "N/A")
                                    userGender: \(userGender?.rawValue ?? "N/A")
                                    userBirthYear: \(userBirthYear ?? "N/A")
                                    userProfile: \(userProfile?.absoluteString ?? "N/A")
                                    """

                                    print(contentText)
                                }
                            }
                        }
                    }
                } else {
                    print("사용자의 추가 동의가 필요하지 않습니다.")
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
                print("logout() success.")
            }
        }
    }
}
