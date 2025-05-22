//
//  SettingToggleRow.swift
//  ChaterView
//
//  Created by 박호건 on 4/12/25.
//

import SwiftUI

struct SettingToggleRow: View {
    let title: String
    let icon: String
    @Binding var isOn: Bool

    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.primaryBlue)

            Text(title)
                .font(.bodyMedium)
                .foregroundColor(.primaryBlue)

            Spacer()

            Toggle("", isOn: $isOn)
                .labelsHidden()
        }
        .padding()
        .background(Color.surface)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

#Preview{
    SettingRow(title: "항상 답보기", icon: "eye")
}
