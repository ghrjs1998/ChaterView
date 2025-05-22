//
//  LoginView.swift
//  ChaterView
//
//  Created by 박호건 on 4/28/25.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    @EnvironmentObject private var appState: AppState
    
    var body: some View {
        VStack(spacing: 40) {
            Text("ChaterView")
                .font(.logoFont)
                .foregroundColor(.primaryBlue)
                .shadow(color: .gray.opacity(0.4), radius: 4, x: 0, y: 2)
            
            Text("간편하게 로그인하고\n면접 연습을 시작하세요!")
                .font(.titleLarge)
                .foregroundColor(.textPrimary)
                .multilineTextAlignment(.center)
                .padding()
            
            Spacer()
            
            VStack(spacing: 16) {
                LoginButton(title: "Google로 로그인", icon: DSImage.google, backgroundColor: .white, foregroundColor: .black,
                            showBorder: true,
                            action: { viewModel.signInWithGoogle(appState: appState) }, disabled: viewModel.isSigningIn)
                
                LoginButton(title: "Kakao로 로그인", icon: .kakao, backgroundColor: .yellow, foregroundColor: .black,
                            showBorder: false,
                            action: { viewModel.signInWithKakao(appState: appState) }, disabled: viewModel.isSigningIn)
                
                LoginButton(title: "Apple로 로그인", icon: .apple, backgroundColor: .black, foregroundColor: .white,
                            showBorder: false,
                            action: { viewModel.signInWithApple(appState: appState) }, disabled: viewModel.isSigningIn)
            }
            .padding(.horizontal, 32)
            
            Spacer()
        }
        .padding(.top, 60)
        .background(Color.background)
    }
}

#Preview {
    LoginView()
}
