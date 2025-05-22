//
//  AnswerTimeLimitSettingView.swift
//  ChaterView
//
//  Created by 박호건 on 4/12/25.
//

import SwiftUI

struct AnswerTimeLimitSettingView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selected: AnswerTimeLimit = UserDefaultManager.answerTimeLimit
    
    var body: some View {
        VStack {
            ZStack {
                Text("답변 시간 제한")
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
            
            List {
                ForEach(AnswerTimeLimit.allCases) { option in
                    HStack {
                        Text(option.displayName)
                            .font(.bodyLarge)
                            .foregroundColor(.primaryBlue)
                        Spacer()
                        if selected == option {
                            Image(systemName: "checkmark")
                                .foregroundColor(.primaryBlue)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selected = option
                        UserDefaultManager.answerTimeLimit = option
                    }
                }
            }
        }
//        .background(Color.background)
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    AnswerTimeLimitSettingView()
}
