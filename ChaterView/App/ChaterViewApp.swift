//
//  ChaterViewApp.swift
//  ChaterView
//
//  Created by 박호건 on 4/9/25.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import KakaoSDKCommon

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        if let kakaoAppKey = Bundle.main.object(forInfoDictionaryKey: "KAKAO_APP_KEY") as? String {
            print("✅ Kakao App Key: \(kakaoAppKey)")
            KakaoSDK.initSDK(appKey: kakaoAppKey)
        } else {
            print("❌ Kakao App Key 로딩 실패 - Info.plist 확인 필요")
        }
        
        return true
    }
}

@main
struct ChaterViewApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var appState = AppState()

    init() {
//#if DEBUG
//        UserDefaultManager.isOnboardingCompleted = false
//#endif
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
        }
    }
}
