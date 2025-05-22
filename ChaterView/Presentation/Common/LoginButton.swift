//
//  LoginButton.swift
//  ChaterView
//
//  Created by 박호건 on 4/29/25.
//

import SwiftUI

struct LoginButton: View {
    let title: String
    let icon: DSImage
    let backgroundColor: Color
    let foregroundColor: Color
    let showBorder: Bool
    let action: () -> Void
    let disabled: Bool

    var body: some View {
        Button(action: action) {
            HStack {
                icon.toImage()
                Text(title)
                    .font(.bodyLarge)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(backgroundColor)
            .foregroundColor(foregroundColor)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(showBorder ? Color.gray.opacity(0.5) : Color.clear, lineWidth: 1)
            )
            .cornerRadius(12)
        }
        .disabled(disabled)
    }
}
