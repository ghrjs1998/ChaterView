////
////  SettingsView.swift
////  ChaterView
////
////  Created by 박호건 on 4/12/25.
////
//
//// 생성 위치: Presentation/Setting/SettingsView.swift
//
//import SwiftUI
//
//struct SettingsView: View {
//    @Environment(\.dismiss) private var dismiss
//    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
//    @EnvironmentObject private var appState: AppState
//    @StateObject private var logoutViewModel = LogoutViewModel()
//    @State private var showDeleteAlert = false
//
//    var body: some View {
//        NavigationStack {
//            VStack {
//                ZStack {
//                    Text("설정")
//                        .font(.titleMedium)
//                        .foregroundColor(.textPrimary)
//                        .frame(maxWidth: .infinity, alignment: .center)
//
//                    HStack {
//                        Button {
//                            dismiss()
//                        } label: {
//                            Image(systemName: "chevron.left")
//                                .font(.title3)
//                                .foregroundColor(.blue)
//                        }
//                        Spacer()
//                    }
//                }
//                .padding(.horizontal)
//                .padding(.top, 16)
//                .padding(.bottom, 12)
//            }
//            //            Divider()
//            ScrollView {
//                VStack(alignment: .leading, spacing: 24) {
//
//                    // ScrollView 내부
////                    SettingToggleRow(
////                        title: "다크 모드",
////                        icon: "circle.lefthalf.filled",
////                        isOn: $isDarkMode
////                    )
//                    SettingToggleRow(
//                        title: "다크 모드",
//                        icon: "circle.lefthalf.filled",
//                        isOn: Binding(
//                            get: { appState.isDarkMode },
//                            set: { appState.updateDarkMode($0) }
//                        )
//                    )
//
//                    // 학습 통계
//                    NavigationLink(destination: StudyStatisticsSettingView()) {
//                        SettingRow(title: "학습 통계 보기", icon: "chart.bar")
//                    }
//
//                    // 피드백 톤 설정
//                    NavigationLink(destination: FeedbackToneSettingView()) {
//                        SettingRow(title: "피드백 톤 설정", icon: "text.bubble")
//                    }
//
//                    // 북마크 질문 보기
//                    NavigationLink(destination: BookmarkListView()) {
//                        SettingRow(title: "북마크한 질문", icon: "bookmark")
//                    }
//
//                    // 답변시간 설정
//                    NavigationLink(destination: AnswerTimeLimitSettingView()) {
//                        SettingRow(title: "답변 시간 제한", icon: "timer")
//                    }
//
//                    SettingToggleRow(
//                        title: "예시 답 항상 보기",
//                        icon: "text.book.closed",
//                        isOn: Binding(
//                            get: { UserDefaultManager.alwaysShowSampleAnswer },
//                            set: { UserDefaultManager.alwaysShowSampleAnswer = $0 }
//                        )
//                    )
//
//                    // 로그아웃
//                    Button(role: .destructive) {
//                        logoutViewModel.logout(appState: appState)
//                    } label: {
//                        SettingRow(title: "로그아웃", icon: "rectangle.portrait.and.arrow.right", isDestructive: true)
//                    }
//
//                    // 탈퇴하기
//                    Button(role: .destructive) {
//                        showDeleteAlert = true
//                    } label: {
//                        SettingRow(title: "탈퇴하기", icon: "person.crop.circle.badge.xmark", isDestructive: true)
//                    }
//                    .alert("정말 탈퇴하시겠습니까?", isPresented: $showDeleteAlert) {
//                        Button("탈퇴", role: .destructive) {
//                            logoutViewModel.deleteAccount(appState: appState)
//                        }
//                        Button("취소", role: .cancel) {}
//                    } message: {
//                        Text("탈퇴 시 정보가 모두 삭제됩니다.")
//                    }
//
////#if DEBUG
////                    Divider()
////                    VStack(alignment: .leading, spacing: 12) {
////                        Text("디버그 전용")
////                            .font(.headline)
////
////                        Button(role: .destructive) {
////                            UserDefaultManager.resetAllStatistics()
////                        } label: {
////                            Label("학습 통계 초기화", systemImage: "trash")
////                        }
////                    }
////                    .padding(.top, 8)
////#endif
//
//                    Spacer().frame(height: 100)
//
//
//                    // 앱 버전 정보
//                    HStack {
//                        Spacer()
//                        Text("버전 \(AppInfo.version) (\(AppInfo.build))")
//                            .font(.footnote)
//                            .foregroundColor(.secondary)
//                        Spacer()
//                    }
//                }
//                .padding()
//            }
//        }
//        .navigationBarBackButtonHidden(true)
//    }
//}
//
//#Preview {
//    SettingsView()
//}

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    @EnvironmentObject private var appState: AppState
    @StateObject private var logoutViewModel = LogoutViewModel()
//    @StateObject private var profileViewModel = UserProfileViewModel()
    @State private var showDeleteAlert = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // MARK: - Top Bar
                    ZStack {
                        Text("설정")
                            .font(.titleMedium)
                            .foregroundColor(.textPrimary)
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                        HStack {
                            Button {
                                dismiss()
                            } label: {
                                Image(systemName: "chevron.left")
                                    .font(.title3)
                                    .foregroundColor(.primaryBlue)
                            }
                            Spacer()
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 16)
                    .padding(.bottom, 12)
                    
                    // MARK: - 프로필 카드
//                    if let profile = profileViewModel.profile {
                        UserProfileCard(badge: BadgeLevel.calculateBadge(uniqueCount: UserDefaultManager.uniqueAnsweredIDs.count, match: UserDefaultManager.averageKeywordMatch))
                            .environmentObject(appState)
                            .padding(.horizontal)
//                    }
                    
                    // MARK: - 설정 항목
                    VStack(alignment: .leading, spacing: 24) {
                        SettingToggleRow(
                            title: "다크 모드",
                            icon: "circle.lefthalf.filled",
                            isOn: Binding(
                                get: { appState.isDarkMode },
                                set: { appState.updateDarkMode($0) }
                            )
                        )
                        
                        NavigationLink(destination: StudyStatisticsSettingView()) {
                            SettingRow(title: "학습 통계 보기", icon: "chart.bar")
                        }
                        
                        NavigationLink(destination: FeedbackToneSettingView()) {
                            SettingRow(title: "피드백 톤 설정", icon: "text.bubble")
                        }
                        
                        NavigationLink(destination: BookmarkListView()) {
                            SettingRow(title: "북마크한 질문", icon: "bookmark")
                        }
                        
                        NavigationLink(destination: AnswerTimeLimitSettingView()) {
                            SettingRow(title: "답변 시간 제한", icon: "timer")
                        }
                        
                        SettingToggleRow(
                            title: "예시 답 항상 보기",
                            icon: "text.book.closed",
                            isOn: Binding(
                                get: { UserDefaultManager.alwaysShowSampleAnswer },
                                set: { UserDefaultManager.alwaysShowSampleAnswer = $0 }
                            )
                        )
                        
                        // MARK: - 로그아웃 & 탈퇴
                        Button(role: .destructive) {
                            logoutViewModel.logout(appState: appState)
                        } label: {
                            SettingRow(title: "로그아웃", icon: "rectangle.portrait.and.arrow.right", isDestructive: true)
                        }
                        
                        Button(role: .destructive) {
                            showDeleteAlert = true
                        } label: {
                            SettingRow(title: "탈퇴하기", icon: "person.crop.circle.badge.xmark", isDestructive: true)
                        }
                        .alert("정말 탈퇴하시겠습니까?", isPresented: $showDeleteAlert) {
                            Button("탈퇴", role: .destructive) {
                                logoutViewModel.deleteAccount(appState: appState)
                            }
                            Button("취소", role: .cancel) {}
                        } message: {
                            Text("탈퇴 시 정보가 모두 삭제됩니다.")
                        }
                        
                        // MARK: - 버전 정보
                        HStack {
                            Spacer()
                            Text("버전 \(AppInfo.version) (\(AppInfo.build))")
                                .font(.footnote)
                                .foregroundColor(.secondary)
                            Spacer()
                        }
                        .padding(.top, 32)
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 40)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    SettingsView()
        .environmentObject(AppState())
}
