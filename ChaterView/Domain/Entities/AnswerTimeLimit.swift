//
//  AnswerTimeLimit.swift
//  ChaterView
//
//  Created by 박호건 on 4/12/25.
//

import Foundation

enum AnswerTimeLimit: String, CaseIterable, Identifiable {
    case unlimited = "unlimited"
    case seconds30 = "30s"
    case minute1 = "1m"
    case minute2 = "2m"

    // 유니크 ID
    var id: String { rawValue }

    // 사용자 표시용 이름
    var displayName: String {
        switch self {
        case .unlimited: return "무제한"
        case .seconds30: return "30초"
        case .minute1: return "1분"
        case .minute2: return "2분"
        }
    }

    // 실제 제한 시간 (초 단위)
    var timeInSeconds: Int? {
        switch self {
        case .unlimited: return nil
        case .seconds30: return 30
        case .minute1: return 60
        case .minute2: return 120
        }
    }

    // 편의 초기화 (UserDefaults 값 등에서 불러올 때 안전하게 변환)
    init(raw: String) {
        self = AnswerTimeLimit(rawValue: raw) ?? .unlimited
    }
}
