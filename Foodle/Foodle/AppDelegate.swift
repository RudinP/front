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
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
        let appearance = UITabBarAppearance()
        let tabBar = UITabBar()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.white
        tabBar.standardAppearance = appearance;
        UITabBar.appearance().scrollEdgeAppearance = appearance
        
        settingNaverSNSLogin()
        
        // 메인번들에 있는 카카오 앱키 불러오기
        let kakaoAppKey = Bundle.main.infoDictionary?["KAKAO_NATIVE_APP_KEY"] ?? ""
        
        // kakao SDK 초기화
        KakaoSDK.initSDK(appKey: kakaoAppKey as! String)
        
        user = UserDefaultsManager.userData
        
        UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplication.backgroundFetchIntervalMinimum)
        
        NotificationManager.shared.requestAuthorization()
        
        return true
    }
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if let userData = UserDefaultsManager.userData{
            user = userData
            runDailyTask()
        }
        completionHandler(.newData)
    }
    
    func runDailyTask() {
        if let userId = user?.uid{
            fetchMeeting(userId) { result in
                let originMeetingsCount = UserDefaults.standard.integer(forKey: "MeetingsCount")
                let newMeetingsCount = result?.count ?? originMeetingsCount
                if originMeetingsCount != newMeetingsCount{
                    self.alertNewMeetings()
                }
            }
        }
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    func alertNewMeetings(){
        let content = UNMutableNotificationContent()
        content.title = "알림"
        content.body = "새로운 약속을 확인해주세요"
        content.sound = .default
        content.badge = 1
        
        let request = UNNotificationRequest(identifier: "DailyTaskNotification", content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            }
        }
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        NaverThirdPartyLoginConnection.getSharedInstance().application(app, open: url, options: options)
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
        
        let container = NSPersistentContainer(name: "Foodle")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func applicationWillTerminate(_ application: UIApplication) {
        saveUserData()
    }
    
    func saveUserData() {
        let meetingsCount = meetings?.count ?? 0
        UserDefaults.standard.setValue(meetingsCount, forKey: "MeetingsCount")
    }
    
    
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
