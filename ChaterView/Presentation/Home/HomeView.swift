//
//  HomeView.swift
//  ChaterView
//
//  Created by 박호건 on 4/9/25.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    var body: some View {
        NavigationStack {
            VStack(spacing: 32) {
                HStack {
                    Text("ChaterView")
                        .font(.logoFont) // 크고 두껍게, 라운드 디자인
                        .foregroundColor(.primaryBlue) // 브랜드 컬러 느낌
                        .shadow(color: .gray.opacity(0.4), radius: 4, x: 0, y: 2) // 살짝 그림자 추가
                    
                    
                    Spacer()
                    
                    NavigationLink(destination: SettingsView()) {
                        Image(systemName: "gearshape")
                            .font(.system(size: 30, weight: .black, design: .rounded))
                            .foregroundColor(.secondary)
                            .frame(width: 44, height: 44)
                            .background(Color.clear)
                    }
                }
                .padding(.top, 10)
                .padding(.horizontal)
                
                
                Text("어떤 분야 면접을 \n준비할까요?")
                    .font(.titleLarge)
                    .foregroundColor(.textPrimary)
                    .multilineTextAlignment(.center)
                    .padding(.top, 12)
                
                Spacer()
                
                ForEach(CategoryType.allCases, id:\.self) { category in
                    Button {
                        viewModel.selectCategory(category)
                    } label: {
                        Text(category.displayName)
                            .font(.bodyLarge)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(category.color)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(category == .ios ? Color.white.opacity(0.2) : Color.clear, lineWidth: 1)
                            )
                            .cornerRadius(12)
                    }
                }
                .padding(.horizontal, 24)
                
                Spacer()
            }
            .padding()
            .navigationDestination(isPresented: $viewModel.navigateToInterView) {
                if let selectedCategory = viewModel.selectedCategory {
                    InterviewView(viewModel: InterviewViewModel(category: selectedCategory))
                }
            }
            .navigationBarBackButtonHidden()
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    HomeView()
}
