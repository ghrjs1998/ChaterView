//
//  ContentView.swift
//  ChaterView
//
//  Created by 박호건 on 4/9/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var appState: AppState

    var body: some View {
        Group {
            if !appState.isInitialized {
                SplashView()
                    .transition(.opacity)
            } else {
                if !UserDefaultManager.isOnboardingCompleted {
                    OnboardingView()
                        .transition(.opacity)
                } else {
                    if appState.isLoggedIn {
                        HomeView()
                            .transition(.opacity)
                    } else {
                        LoginView()
                            .transition(.opacity)
                    }
                }
            }
        }
        .preferredColorScheme(appState.isDarkMode ? .dark : .light)
        .animation(.easeInOut(duration: 0.3), value: appState.isInitialized)
    }
}

#Preview {
    ContentView()
        .environmentObject(AppState())
}
