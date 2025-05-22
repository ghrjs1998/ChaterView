//
//  Color+.swift
//  ChaterView
//
//  Created by 박호건 on 2025/04/28.
//

import SwiftUI

extension Color {
    // 메인 색상
    static let primaryBlue = Color(hex: "#4F8FFF")
    static let secondaryPurple = Color(hex: "#9B7DFF")
    
    // 배경 색상
    static let background = Color(.systemBackground) // 앱 기본 배경
    static let surface = Color(.secondarySystemBackground)     // 카드, 버튼 등 Surface
    
    // 텍스트 색상
    static let textPrimary = Color.primary // 주요 텍스트
    static let textSecondary = Color.secondary // 보조 텍스트
    
    // 버튼/토글 배경 색상
    static let buttonBackground = Color(hex: "#E5E5EA")
    
    // 경고/에러 색상
    static let errorRed = Color(hex: "#FF3B30")
}

// HEX코드로 Color를 초기화하는 확장
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
