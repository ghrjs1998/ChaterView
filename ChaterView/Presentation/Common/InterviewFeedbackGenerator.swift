//
//  InterviewFeedbackGenerator.swift
//  ChaterView
//
//  Created by 박호건 on 4/9/25.
//

import Foundation

struct InterviewFeedbackGenerator {
    static func generate(for answer: String, question: InterviewQuestion, tone: FeedbackTone) -> String {
        
        guard !question.keywords.isEmpty else {
            return "이 질문에는 피드백을 생성할 수 있는 키워드가 없습니다."
        }
        
        let matched = question.keywords.filter { answer.localizedCaseInsensitiveContains($0) }
        let missed = question.keywords.filter { !answer.localizedCaseInsensitiveContains($0) }
        let ratio = Double(matched.count) / Double(question.keywords.count)
        
        switch tone {
        case .kind:
            return generateKindFeedback(matched: matched, missed: missed, ratio: ratio)
        case .strict:
            return generateStrictFeedback(matched: matched, missed: missed, ratio: ratio)
        case .normal:
            return generateNormalFeedback(matched: matched, missed: missed, ratio: ratio)
        }
    }
    
    private static func generateKindFeedback(matched: [String], missed: [String], ratio: Double) -> String {
        if ratio == 1.0 {
            return "정말 훌륭해요! 완벽한 답변이에요."
        } else if ratio >= 0.6 {
            return "좋아요! 핵심 내용을 잘 짚으셨어요. '\(missed.joined(separator: ", "))' 도 한 번 생각해보면 더 좋겠어요."
        } else if ratio > 0 {
            return "좋은 출발이에요! '\(matched.joined(separator: ", "))' 언급은 좋았고, 추가로 '\(missed.joined(separator: ", "))' 도 고려해보면 어떨까요?"
        } else {
            return "괜찮아요, 누구나 시작은 있어요! '\(missed.joined(separator: ", "))' 도 한번 참고해보세요."
        }
    }
    
    private static func generateNormalFeedback(matched: [String], missed: [String], ratio: Double) -> String {
        if ratio == 1.0 {
            return "완벽해요! 모든 핵심 키워드를 빠짐없이 잘 짚었어요."
        } else if ratio >= 0.6 {
            return "대부분 잘 언급하셨어요. '\(missed.joined(separator: ", "))' 도 포함하면 더 좋겠어요."
        } else if ratio > 0 {
            return "'\(matched.joined(separator: ", "))' 언급은 좋았어요. '\(missed.joined(separator: ", "))' 도 함께 설명해보면 좋겠습니다."
        } else {
            return "'\(missed.joined(separator: ", "))' 같은 키워드를 포함해서 더 구체적으로 답해보세요."
        }
    }
    
    private static func generateStrictFeedback(matched: [String], missed: [String], ratio: Double) -> String {
        if ratio == 1.0 {
            return "그 정도면 아주 우수한 답변입니다. 훌륭해요."
        } else if ratio >= 0.6 {
            return "다소 부족한 감이 있어요. '\(missed.joined(separator: ", "))' 를 보완하면 더 정확한 답이 됩니다."
        } else if ratio > 0 {
            return "핵심 개념이 일부 빠졌습니다. '\(matched.joined(separator: ", "))' 은 괜찮지만, '\(missed.joined(separator: ", "))' 을 반드시 포함해야 합니다."
        } else {
            return "답변이 매우 부족합니다. '\(missed.joined(separator: ", "))' 같은 개념은 꼭 짚고 넘어가야 합니다."
        }
    }
}
