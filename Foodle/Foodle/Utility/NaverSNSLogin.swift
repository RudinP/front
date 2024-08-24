import Foundation
import NaverThirdPartyLogin
import Alamofire

class NaverSNSLogin: NSObject {
    
    //싱글톤 접근 상수
    static let shared: NaverSNSLogin = NaverSNSLogin()
    
    //네이버 로그인 인스턴스
    private let instance = NaverThirdPartyLoginConnection.getSharedInstance()
    
    //네이버 로그인 성공시 처리
    var success: ((_ loginData: NaverLogin) -> Void)? = { loginData in
        let response = loginData.response
        let userInfo = User(uid:response.id, profileImage: response.profile_image, name: response.name, nickName: response.nickname)
        guard let uid = userInfo.uid else {return}
        let group = DispatchGroup()
        group.enter()
        fetchUser(uid) { result in
            guard let result else {
                createUser(userInfo) {
                    guard let uid = userInfo.uid else {
                        group.leave()
                        return
                    }
                    fetchUser(uid) { result in
                        user = result
                    }
                }
                return
            }
            user = result
            print(result)
            group.leave()
        }
        group.notify(queue: . main) {
            NotificationCenter.default.post(name: .loginCompleted, object: nil)
        }
        
    }
    //네이버 로그인 실패시 처리
    var failure: ((_ error: AFError) -> Void)? = { error in
        print(error.localizedDescription)
        //doSomething
    }
    
    //네이버 사용자 정보를 받아올 구조체
    struct NaverLogin: Decodable {
        var resultCode: String
        var response: Response
        var message: String
        
        struct Response: Decodable {
            var id: String
            var name: String
            var nickname: String
            var profile_image: String
        }
        
        enum CodingKeys: String, CodingKey {
            case resultCode = "resultcode"
            case response
            case message
        }
    }
    
    // 사용자 정보를 받아오기 전에 토큰 체크
    private func getInfo() {
        
        guard let isValidAccessToken = instance?.isValidAccessTokenExpireTimeNow() else {
            //로그인 필요
            login(){}
            return
        }
        
        if !isValidAccessToken {
            //접근 토큰 갱신 필요
            refreshToken()
            return
        } else {
            userInfo()
        }
    }
    
    //로그인 한다.
    func login(completion: @escaping () -> Void) {
        instance?.delegate = self
        instance?.requestThirdPartyLogin()
    }
    
    //토큰을 갱신한다.
    func refreshToken() {
        instance?.delegate = self
        self.instance?.requestAccessTokenWithRefreshToken()
    }
    
    //로그아웃한다.
    func logout() {
        instance?.delegate = self
        //SampleAppUser.shared.removeAllData()    //앱에 저장된 사용자 정보 삭제
        instance?.resetToken()
    }
    
    //네이버 로그인 서비스 연결을 해지한다.
    func disConnect() {
        instance?.delegate = self
        //SampleAppUser.shared.removeAllData()    //앱에 저장된 사용자 정보 삭제
        instance?.requestDeleteToken()
    }
    
    //사용자 정보를 받아온다.
    func userInfo() {
        
        guard let tokenType = instance?.tokenType else { return }
        guard let accessToken = instance?.accessToken else { return }
        
        let urlStr = "https://openapi.naver.com/v1/nid/me"
        let url = URL(string: urlStr)!
        
        let authorization = "\(tokenType) \(accessToken)"
        let req = AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization": authorization])
        
        req.responseDecodable(of: NaverLogin.self) { [self] response in
            print(response)
            print(response.result)
            
            switch response.result {
            case .success(let loginData):
                print(loginData.resultCode)
                print(loginData.message)
                print(loginData.response)
                
                if let success = self.success {
                    success(loginData)
                }
                
                break
            case .failure(let error):
                print("error: \(error.localizedDescription)")
                
                if let failure = self.failure {
                    failure(error)
                }
                
                break
            }
        }
    }
}


//MARK: - Naver Login Delegate
extension NaverSNSLogin: NaverThirdPartyLoginConnectionDelegate {
    // 로그인에 성공한 경우 호출 됨
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        print("네이버 로그인 성공")
        getInfo()
    }
    // 토큰 갱신 성공 시 호출 됨
    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
        print("네이버 토큰 갱신 성공")
        getInfo()
    }
    // 연동해제 성공한 경우 호출 됨
    func oauth20ConnectionDidFinishDeleteToken() {
        print("네이버 연동 해제 성공")
    }
    // 모든 error인 경우 호출 됨
    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        let alert = UIAlertController(title: "네이버 SNS 로그인 실패", message: "이유: \(String(error.localizedDescription))\n문제가 반복된다면 관리자에게 문의하세요.", preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default)
        alert.addAction(ok)
        
        //topViewController를 구해서, 있으면 alert을 띄움
        if let vc = UIApplication.topViewController(base: nil) {
            vc.present(alert, animated: true)
        }
    }
    
}

extension UIApplication {
    class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}
