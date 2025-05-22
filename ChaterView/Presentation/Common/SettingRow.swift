//
//  SettingRow.swift
//  ChaterView
//
//  Created by 박호건 on 4/12/25.
//

import SwiftUI

struct SettingRow: View {
    let title: String
    let icon: String
    var isDestructive: Bool = false
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(isDestructive ? .errorRed : .primaryBlue)
            Text(title)
                .font(.bodyMedium)
                .foregroundColor(isDestructive ? .errorRed : .primaryBlue)
            Spacer()
        }
        .padding()
        .background(Color.surface)
        .cornerRadius(12)
        .shadow(color:Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

#Preview {
    SettingRow(title: "여기", icon: "오빠", isDestructive: true)
}
