import UIKit
import Security

enum Provider {
    case kakao
    case naver
}

func saveTokenToKeychain(token: String) {
    let tokenData = token.data(using: .utf8)!
    let query: [String: Any] = [
        kSecClass as String: kSecClassGenericPassword,
        kSecAttrAccount as String: "authToken",
        kSecValueData as String: tokenData
    ]

    SecItemDelete(query as CFDictionary) // 기존 토큰 삭제
    let status = SecItemAdd(query as CFDictionary, nil)
    if status == errSecSuccess {
        print("Token saved successfully.")
    } else {
        print("Failed to save token.")
    }
}

func loadTokenFromKeychain() -> String? {
    let query: [String: Any] = [
        kSecClass as String: kSecClassGenericPassword,
        kSecAttrAccount as String: "authToken",
        kSecReturnData as String: kCFBooleanTrue!,
        kSecMatchLimit as String: kSecMatchLimitOne
    ]

    var item: CFTypeRef?
    let status = SecItemCopyMatching(query as CFDictionary, &item)
    if status == errSecSuccess, let data = item as? Data {
        return String(data: data, encoding: .utf8)
    }
    return nil
}

func saveUserInfo(userId: String, email: String, name: String) {
    UserDefaults.standard.set(userId, forKey: "userId")
    UserDefaults.standard.set(email, forKey: "email")
    UserDefaults.standard.set(name, forKey: "name")
}

func updateAuthenticationState() {
    let storyboard = UIStoryboard(name: "Jinhee", bundle: nil)
    let mainViewController = storyboard.instantiateViewController(withIdentifier: "LaunchVC")
    UIApplication.shared.windows.first?.rootViewController = mainViewController
}

func handleOAuthResponse(url: URL) {
    let pathComponents = url.pathComponents
    if pathComponents.count > 2 {
        let token = pathComponents[1]
        let expiry = pathComponents[2]
        saveTokenToKeychain(token: token)
        saveUserInfo(userId: "exampleUserId", email: "example@example.com", name: "Example Name")
        updateAuthenticationState()
        print("Token: \\(token), Expiry: \\(expiry)")
    }
}

func validateToken(token: String, provider: Provider, completion: @escaping (Bool) -> Void) {

    switch provider {
    case .kakao:
        url?.append(path: "/api/v1/auth/oauth2/kakao")
    case .naver:
        url?.append(path: "/api/v1/auth/oauth2/naver")
    }

    guard let requestUrl = url else {
        completion(false)
        return
    }

    var request = URLRequest(url: requestUrl)
    request.httpMethod = "GET"
    request.addValue("Bearer \\(token)", forHTTPHeaderField: "Authorization")

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data, error == nil else {
            completion(false)
            return
        }

        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
            completion(true)
        } else {
            completion(false)
        }
    }
    task.resume()
}

func naverLogin(){
    // Example usage
    let token = "YOUR_ACCESS_TOKEN"
    let provider = Provider.naver // or .naver

    validateToken(token: token, provider: provider) { isValid in
        if isValid {
            print("Token is valid.")
        } else {
            print("Token is invalid.")
        }
    }
}

