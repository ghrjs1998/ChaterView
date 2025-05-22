//
//  FeedbackTone.swift
//  ChaterView
//
//  Created by 박호건 on 4/12/25.
//

import Foundation

enum FeedbackTone: String, CaseIterable, Identifiable {
    case normal
    case kind
    case strict
    
    var id: String{ rawValue }
    
    var displayName: String {
        switch self {
        case .normal: return "기본"
        case .kind: return "칭찬 위주"
        case .strict: return "깐깐하게"
        }
    }
}
