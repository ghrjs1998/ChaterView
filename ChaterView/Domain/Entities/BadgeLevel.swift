//
//  BadgeLevel.swift
//  ChaterView
//
//  Created by 박호건 on 4/30/25.
//

import SwiftUI

enum BadgeLevel: String, Codable, CaseIterable {
    case beginner
    case intermediate
    case expert
    
    // 뱃지 계산
    static func calculateBadge(uniqueCount: Int, match: Double) -> BadgeLevel {
        if uniqueCount >= 150 && match >= 0.8 {
            return .expert
        } else if uniqueCount >= 50 && match >= 0.6 {
            return .intermediate
        } else {
            return .beginner
        }
    }
    
    var image: Image {
        switch self {
        case .beginner: return DSImage.bronze_medal.toImage()
        case .intermediate: return DSImage.silver_medal.toImage()
        case .expert: return DSImage.gold_medal.toImage()
        }
    }
    
    var color: Color {
        switch self {
        case .beginner: return .gray
        case .intermediate: return .blue
        case .expert: return .orange
            
        }
    }
}
