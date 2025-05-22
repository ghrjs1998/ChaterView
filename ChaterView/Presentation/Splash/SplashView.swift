////
////  SplashView.swift
////  ChaterView
////
////  Created by 박호건 on 4/29/25.
////
//
//import SwiftUI
//import FirebaseAuth
//
//struct SplashView: View {
//    @EnvironmentObject private var appState: AppState
//    @State private var isActive = false
//
//    var body: some View {
//        ZStack {
//            Color.background
//                .ignoresSafeArea()
//
//            Text("ChaterView")
//                .font(.system(size: 40, weight: .black, design: .rounded))
//                .foregroundColor(.primaryBlue)
//                .shadow(color: .gray.opacity(0.4), radius: 4, x: 0, y: 2)
//                .opacity(isActive ? 1 : 0.5)
//                .scaleEffect(isActive ? 1.1 : 0.9)
//                .animation(.easeInOut(duration: 1.0), value: isActive)
//        }
//        .onAppear {
//            isActive = true
//
//            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
//                if Auth.auth().currentUser != nil {
//                    appState.isLoggedIn = true
//                } else {
//                    appState.isLoggedIn = false
//                }
//            }
//        }
//        .fullScreenCover(isPresented: .constant(appState.isLoggedIn || !appState.isLoggedIn)) {
//            if appState.isLoggedIn {
//                HomeView()
//            } else {
//                LoginView()
//            }
//        }
//    }
//}
//
//#Preview {
//    SplashView()
//        .environmentObject(AppState())
//}

import SwiftUI
import FirebaseAuth

struct SplashView: View {
    @EnvironmentObject private var appState: AppState
    @State private var isActive = false

    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()

            Text("ChaterView")
                .font(.logoFont)
                .foregroundColor(.primaryBlue)
                .shadow(color: .gray.opacity(0.4), radius: 4, x: 0, y: 2)
                .opacity(isActive ? 1 : 0.5)
                .scaleEffect(isActive ? 1.1 : 0.9)
                .animation(.easeInOut(duration: 1.0), value: isActive)
        }
        .onAppear {
            isActive = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                if Auth.auth().currentUser != nil {
                    appState.isLoggedIn = true
                } else {
                    appState.isLoggedIn = false
                }
                appState.isInitialized = true // **여기서 초기화 완료 표시**
            }
        }
    }
}

#Preview {
    SplashView()
        .environmentObject(AppState())
}
