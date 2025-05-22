//
//  CategoryType.swift
//  ChaterView
//
//  Created by 박호건 on 4/9/25.
//

import Foundation
import SwiftUI

enum CategoryType: String, CaseIterable, Codable {
    case frontend
    case backend
    case android
    case ios
    
    var displayName: String {
        switch self {
        case .frontend: return "프론트앤드"
        case .backend: return "백엔드"
        case .android: return "안드로이드"
        case .ios: return "iOS"
        }
    }
    
    var color: Color {
        switch self {
        case .frontend: return Color(hex: "#4F8FFF")
        case .backend: return Color(hex: "#6E44FF")
        case .android: return Color(hex: "#00C853")
        case .ios: return Color(hex: "#111111")
        }
    }
}
