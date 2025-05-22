//
//  LogoutViewModel.swift
//  ChaterView
//
//  Created by 박호건 on 4/29/25.
//

import Foundation
import FirebaseAuth
import KakaoSDKUser

final class LogoutViewModel: ObservableObject {
    // MARK: - 로그아웃
    func logout(appState: AppState) {
        // firebase 로그아웃
        do {
            try Auth.auth().signOut()
            print("Firebase 로그아웃 성공")
        } catch {
            print("Firebase 로그아웃 실패: \(error.localizedDescription)")
        }
        
        // kakao 로그아웃(optional, 실패해도 무시)
//        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.logout { error in
                if let error = error {
                    print("카카오 로그아웃 실페: \(error.localizedDescription)")
                } else {
                    print("카카오 로그아웃 성공")
                }
//            }
        }
        
        // 앱 상태 변경
//        DispatchQueue.main.async {
//            appState.isLoggedIn = false
//        }
        UserDefaultManager.userName = nil
            appState.userName = nil
            appState.isLoggedIn = false
            appState.isInitialized = false
    }
    
    // MARK: - 탈퇴하기
//    func deleteAccount(appState: AppState) {
//        guard let user = Auth.auth().currentUser else { return }
//        
//        user.delete { error in
//            if let error = error {
//                print("Firebase 계정 삭제 실패: \(error.localizedDescription)")
//            } else {
//                print("Firebase 계정 삭제 성공")
//                self.unlinkKakao()
//                DispatchQueue.main.async {
//                    appState.isLoggedIn = false
//                }
//            }
//        }
//    }
    
    func deleteAccount(appState: AppState) {
        if let user = Auth.auth().currentUser {
            // ✅ Firebase 유저가 있을 때
            user.delete { error in
                if let error = error {
                    print("❌ Firebase 계정 삭제 실패: \(error.localizedDescription)")
                } else {
                    print("✅ Firebase 계정 삭제 성공")
                }

                // regardless of success
                self.unlinkKakao()
                DispatchQueue.main.async {
                    appState.userName = nil
                    appState.isLoggedIn = false
                    appState.isInitialized = false
                }
            }
        } else {
            // ✅ Firebase 유저 없음 → Kakao만 unlink
            print("✅ Firebase 유저 없음 → Kakao unlink만 수행")
            self.unlinkKakao()
            DispatchQueue.main.async {
                appState.userName = nil
                appState.isLoggedIn = false
                appState.isInitialized = false
            }
        }
    }
    
    private func unlinkKakao() {
        UserApi.shared.unlink{ error in
            if let error = error  {
                print("카카오 연결 해제 실패: \(error.localizedDescription)")
            } else {
                print("카카오 연결 해제 성공")
            }
        }
    }
}
