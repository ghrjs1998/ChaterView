//
//  OnboardingView.swift
//  ChaterView
//
//  Created by 박호건 on 4/29/25.
//

import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject private var appState: AppState
    @StateObject private var viewModel = OnboardingViewModel()

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    viewModel.skipOnboarding(appState: appState)
                }) {
                    Text("건너뛰기")
                        .font(.bodySmall)
                        .foregroundColor(.textSecondary)
                        .padding(16)
                }
            }

            TabView(selection: $viewModel.currentPage) {
                ForEach(0..<viewModel.pages.count, id: \.self) { index in
                    VStack(spacing: 24) {
                        viewModel.pages[index].image.toImage()
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 520)
                            .cornerRadius(20)
                            .shadow(radius: 5)
                        
                        Text(viewModel.pages[index].title)
                            .font(.titleMedium)
                            .foregroundColor(.textPrimary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 24)
                    }
                    .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .animation(.easeInOut, value: viewModel.currentPage)
            
            // 커스텀 페이지 인디케이터
            HStack(spacing: 8) {
                ForEach(0..<viewModel.pages.count, id: \.self) { index in
                    Circle()
                        .fill(viewModel.currentPage == index ? Color.primaryBlue : Color.gray.opacity(0.5))
                        .frame(width: 8, height: 8)
                }
            }
            .padding(.top, 12)
            .padding(.bottom, 24)

            Spacer()
            
            Button(action: {
                if viewModel.currentPage < viewModel.pages.count - 1 {
                    withAnimation {
                        viewModel.currentPage += 1
                    }
                } else {
                    viewModel.completeOnboarding(appState: appState)
                }
            }) {
                Text(viewModel.currentPage == viewModel.pages.count - 1 ? "시작하기" : "다음")
                    .font(.bodyLarge)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.primaryBlue)
                    .cornerRadius(12)
                    .padding(.horizontal)
            }
            .padding(.bottom, 30)
        }
        .background(Color.background)
    }
}


#Preview {
    OnboardingView()
        .environmentObject(AppState())
}
