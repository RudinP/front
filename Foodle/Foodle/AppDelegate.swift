//
//  AppDelegate.swift
//  Foodle
//
//  Created by 루딘 on 3/12/24.
//

import UIKit
import CoreData
import KakaoSDKCommon
import NaverThirdPartyLogin
import KakaoSDKCommon

var url = URL(string:"http://ec2-3-39-156-254.ap-northeast-2.compute.amazonaws.com:8080")

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
    
        
        let appearance = UITabBarAppearance()
        let tabBar = UITabBar()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.white
        tabBar.standardAppearance = appearance;
        UITabBar.appearance().scrollEdgeAppearance = appearance
        
        settingNaverSNSLogin()
        let kakaoAppKey = Bundle.main.infoDictionary?["KAKAO_NATIVE_APP_KEY"] ?? ""
        KakaoSDK.initSDK(appKey: kakaoAppKey as! String)
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if let kakaoAppKey = Bundle.main.infoDictionary?["KAKAO_NATIVE_APP_KEY"] as? String {
            if url.scheme == "kakao\(kakaoAppKey)" {
                if let components = URLComponents(url: url, resolvingAgainstBaseURL: false) {
                    if let queryItems = components.queryItems {
                        let params = queryItems.reduce(into: [String: String]()) { (result, item) in
                            result[item.name] = item.value
                        }
                        handleKakaoLink(params: params)
                    }
                }
                return true
            }
        } else {
            NaverThirdPartyLoginConnection.getSharedInstance().application(app, open: url, options: options)
        }
        return false
    }

    func handleKakaoLink(params: [String: String]) {
        if let uid = params["uid"], let fid = params["fid"] {
            // 친구 추가 로직
            print("Add friend with uid: \(uid), fid: \(fid)")
            
            // 서버에 친구 추가 요청을 보내기
            let urlString = "http://3.39.156.254:8080/api/friends/Create?uid=\(uid)&fid=\(fid)"
            
            guard let url = URL(string: urlString) else {
                print("Invalid URL")
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    print("Invalid response")
                    return
                }
                
                if let data = data {
                    let responseString = String(data: data, encoding: .utf8)
                    print("Response: \(responseString ?? "")")
                }
            }
            
            task.resume()
        }
    }

    /// 네이버 로그인 셋팅
        func settingNaverSNSLogin() {
            
            let instance = NaverThirdPartyLoginConnection.getSharedInstance()
            //네이버 앱으로 인증하는 방식 활성화
            instance?.isNaverAppOauthEnable = true
            //SafariViewController에서 인증하는 방식 활성화
            instance?.isInAppOauthEnable = true
            //인증 화면을 아이폰의 세로모드에서만 적용
            instance?.isOnlyPortraitSupportedInIphone()
            
            instance?.serviceUrlScheme = "foodle"
            instance?.consumerKey = "WLeUMAvND1zA5FO1oAG8"
            instance?.consumerSecret = "MRUyHLBRkT"
            instance?.appName = "foodle"
        }


    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "Foodle")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}

extension Notification.Name {
    static let didLoadData = Notification.Name("didLoadData")
}
