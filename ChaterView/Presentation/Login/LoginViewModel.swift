//
//  LoginViewModel.swift
//  ChaterView
//
//  Created by 박호건 on 4/28/25.
//

import SwiftUI
import FirebaseAuth
import GoogleSignIn
import FirebaseCore
import KakaoSDKUser
import KakaoSDKAuth
import AuthenticationServices
import CryptoKit

final class LoginViewModel: NSObject, ObservableObject {
    @Published var isSigningIn: Bool = false
    private var currentNonce: String?
    private var appState: AppState?
    
    // MARK: - Google 로그인
    func signInWithGoogle(appState: AppState) {
        isSigningIn = true
        
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            print("Firebase ClientID 없음")
            isSigningIn = false
            return
        }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else {
            print("RootViewController 찾기 실패")
            isSigningIn = false
            return
        }
        
        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { result, error in
            if let error = error {
                print("Google 로그인 실패: \(error.localizedDescription)")
                self.isSigningIn = false
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString else {
                print("사용자 토큰 가져오기 실패")
                self.isSigningIn = false
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: user.accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    print("Firebase 로그인 실패: \(error.localizedDescription)")
                } else {
                    print("Firebase 로그인 성공! UID: \(authResult?.user.uid ?? "없음")")
                    DispatchQueue.main.async {
                        appState.userName = Auth.auth().currentUser?.displayName
                        appState.isLoggedIn = true // 로그인 완료 시 상태 변경
                    }
                }
                self.isSigningIn = false
            }
        }
    }
    
    // MARK: - Kakao 로그인
    //    func signInWithKakao(appState: AppState) {
    //        isSigningIn = true
    //
    //        // 카카오 설치 여부 확인 후 로그인 방식 결정
    //        if UserApi.isKakaoTalkLoginAvailable() {
    //            UserApi.shared.loginWithKakaoTalk { oauthToken, error in
    //                if let error = error {
    //                    print("카카오 앱 로그인 실패 \(error.localizedDescription)")
    //                    self.isSigningIn = false
    //                } else {
    //                    print("카카오톡 앱 로그인 성공")
    //                    DispatchQueue.main.async {
    //                        appState.isLoggedIn = true
    //                    }
    //                    self.isSigningIn = false
    //                }
    //            }
    //        } else {
    //            UserApi.shared.loginWithKakaoAccount { oauthToken, error in
    //                if let error = error {
    //                    print("카카오 웹 로그인 실패: \(error.localizedDescription)")
    //                    self.isSigningIn = false
    //                } else {
    //                    print("카카오 웹 로그인 성공")
    //                    DispatchQueue.main.async {
    //                        appState.isLoggedIn = true
    //                    }
    //                    self.isSigningIn = false
    //                }
    //            }
    //        }
    //    }
    // MARK: - Kakao 로그인
    func signInWithKakao(appState: AppState) {
        isSigningIn = true
        self.appState = appState
        
        let handleLoginResult: (OAuthToken?, Error?) -> Void = { oauthToken, error in
            if let error = error {
                print("❌ 카카오 로그인 실패: \(error.localizedDescription)")
                self.isSigningIn = false
                return
            }
            
            print("✅ 카카오 로그인 성공 - 토큰 획득")
            
            // 사용자 정보 조회
            UserApi.shared.me { user, error in
                DispatchQueue.main.async {
                    
                    if let error = error {
                        print("❌ 사용자 정보 조회 실패: \(error.localizedDescription)")
                        self.isSigningIn = false
                        return
                    }
                    if let nickname = user?.kakaoAccount?.profile?.nickname {
                        print("✅ 사용자 닉네임: \(nickname)")
                        appState.userName = nickname
                    }
                    
                    
                    appState.isLoggedIn = true
                    self.isSigningIn = false
                }
            }
        }
        
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.loginWithKakaoTalk(completion: handleLoginResult)
        } else {
            UserApi.shared.loginWithKakaoAccount(completion: handleLoginResult)
        }
        
    }
    
    // MARK: - Apple 로그인
    func signInWithApple(appState: AppState) {
        isSigningIn = true
        self.appState = appState
        
        let nonce = randomNonceString()
        currentNonce = nonce
        
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
}

// MARK: - Apple Delegate
extension LoginViewModel: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
              let nonce = currentNonce,
              let appleIDToken = appleIDCredential.identityToken,
              let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
            isSigningIn = false
            return
        }
        
        if let fullName = appleIDCredential.fullName {
            let name = [fullName.familyName, fullName.givenName]
                .compactMap { $0 }
                .joined()
            self.appState?.userName = name.isEmpty ? "사용자" : name
        }
        
        let credential = OAuthProvider.appleCredential(
            withIDToken: idTokenString,
            rawNonce: nonce,
            fullName: appleIDCredential.fullName
        )
        
        Auth.auth().signIn(with: credential) { result, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Apple 로그인 실패: \(error.localizedDescription)")
                } else {
                    print("Apple 로그인 성공!")
                    if let displayName = Auth.auth().currentUser?.displayName, !displayName.isEmpty {
                        print("Apple DisplayName 사용: \(displayName)")
                        self.appState?.userName = displayName
                        UserDefaultManager.userName = displayName
                    } else if let fullName = appleIDCredential.fullName {
                        let name = [fullName.familyName, fullName.givenName]
                            .compactMap { $0 }
                            .joined()
                        let finalName = name.isEmpty ? "사용자" : name
                        print("Apple FullName 조합 사용: \(finalName)")
                        self.appState?.userName = finalName
                        UserDefaultManager.userName = finalName
                        
                        
                    } else if let storedName = UserDefaultManager.userName {
                        print("저장된 이름 사용 \(storedName)")
                        self.appState?.userName = storedName
                    } else {
                        self.appState?.userName = "사용자"
                        UserDefaultManager.userName = "사용자"
                        print("기본 이름 사용: 사용자")
                    }
                    
                    self.appState?.isLoggedIn = true
                }
                self.isSigningIn = false
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Apple 로그인 에러: \(error.localizedDescription)")
        isSigningIn = false
    }
}

extension LoginViewModel: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return UIApplication.shared.windows.first ?? UIWindow()
    }
}

// MARK: - nonce 유틸리티
extension LoginViewModel {
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            var random: UInt8 = 0
            let status = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
            if status == errSecSuccess {
                if random < charset.count {
                    result.append(charset[Int(random) % charset.count])
                    remainingLength -= 1
                }
            }
        }
        return result
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashed = SHA256.hash(data: inputData)
        return hashed.map { String(format: "%02x", $0) }.joined()
    }
}
