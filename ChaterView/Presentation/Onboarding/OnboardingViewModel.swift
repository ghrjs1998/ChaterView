//
//  OnboardingViewModel.swift
//  ChaterView
//
//  Created by 박호건 on 4/29/25.
//

import SwiftUI

final class OnboardingViewModel: ObservableObject {
    @Published var currentPage: Int = 0

    let pages: [OnboardingPage] = [
        OnboardingPage(image: .onboarding_home, title: "원하는 분야를 선택하세요"),
        OnboardingPage(image: .onboarding_interview, title: "실전처럼 연습하고 피드백을 받아보세요"),
        OnboardingPage(image: .onboarding_settings, title: "나만의 설정으로 앱을 맞춤화하세요")
    ]

    func completeOnboarding(appState: AppState) {
        UserDefaultManager.isOnboardingCompleted = true
        appState.isInitialized = true
    }

    func skipOnboarding(appState: AppState) {
        completeOnboarding(appState: appState)
    }
}
