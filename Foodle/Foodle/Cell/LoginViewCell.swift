//
//  LoginViewCell.swift
//  Foodle
//
//  Created by 민정 on 3/19/24.
//

import UIKit

class LoginViewCell: UIViewController {
    @IBOutlet var loginLabel: UILabel!
    @IBOutlet var loginLabel2: UILabel!
    @IBOutlet var kakaoImg: UIImageView!
    @IBOutlet var naverImg: UIImageView!
    @IBOutlet var appleImg: UIImageView!
    @IBOutlet var privacyLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        kakaoImg.image = UIImage(named: "icon_kakao.png")
        naverImg.image = UIImage(named: "icon_naver.png")
        appleImg.image = UIImage(named: "icon_apple.png")
        
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
    }
}
