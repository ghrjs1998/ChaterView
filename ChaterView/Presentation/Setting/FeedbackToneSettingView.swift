//
//  FeedbackToneSettingView.swift
//  ChaterView
//
//  Created by 박호건 on 4/12/25.
//

import SwiftUI

struct FeedbackToneSettingView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selected: FeedbackTone = UserDefaultManager.feedbackTone

    var body: some View {
        VStack {
            // 커스텀 네비게이션 바
            ZStack {
                Text("피드백 톤 설정")
                    .font(.titleMedium)
                    .foregroundColor(.primary)
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
                ForEach(FeedbackTone.allCases) { tone in
                    HStack {
                        Text(tone.displayName)
                            .font(.bodyLarge)
                            .foregroundColor(.primaryBlue)
                        Spacer()
                        if selected == tone {
                            Image(systemName: "checkmark")
                                .foregroundColor(.primaryBlue)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selected = tone
                        UserDefaultManager.feedbackTone = tone
                    }
                }
            }
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    FeedbackToneSettingView()
}
