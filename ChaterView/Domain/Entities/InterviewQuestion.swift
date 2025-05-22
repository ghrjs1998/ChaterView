//
//  InterviewQuestion.swift
//  ChaterView
//
//  Created by 박호건 on 4/9/25.
//

import Foundation

struct InterviewQuestion: Identifiable, Codable, Equatable {
    let id: UUID
    let category: CategoryType
    let question: String
    let sampleAnswer: String
    let keywords: [String]
}
