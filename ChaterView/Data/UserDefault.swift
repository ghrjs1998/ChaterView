//
//  UserDefault.swift
//  ChaterView
//
//  Created by 박호건 on 2025/04/14.
//

import Foundation

enum UserDefaultManager {
    private static let defaults = UserDefaults.standard
    
    // MARK: - Key 정의
    enum Key {
        static let feedbackTone = "feedbackTone"
        static let answerTimeLimit = "answerTimeLimit"
        static let isDarkMode = "isDarkMode"
        static let alwaysShowSampleAnswer = "alwaysShowSampleAnswer"
        static let isOnboardingCompleted = "isOnboardingCompleted"
    }
    
    enum StatKey {
        static let totalAnsweredCount = "totalAnsweredCount"
        static let lastStudyDate = "lastStudyDate"
        static let categoryAnswerCount = "categoryAnswerCount"
        static let averageKeywordMatch = "averageKeywordMatch"
        static let uniqueAnsweredIDs = "uniqueAnsweredQuestionIDs"
    }
    
    // MARK: - 사용자 이름
    static var userName: String? {
        get { defaults.string(forKey: "userName") }
        set { defaults.set(newValue, forKey: "userName") }
    }
    
    // MARK: - 피드백 톤
    static var feedbackTone: FeedbackTone {
        get {
            let raw = defaults.string(forKey: Key.feedbackTone) ?? FeedbackTone.normal.rawValue
            return FeedbackTone(rawValue: raw) ?? .normal
        }
        set {
            defaults.set(newValue.rawValue, forKey: Key.feedbackTone)
        }
    }
    
    // MARK: - 답변 시간 제한
    static var answerTimeLimit: AnswerTimeLimit {
        get {
            let raw = defaults.string(forKey: Key.answerTimeLimit) ?? AnswerTimeLimit.unlimited.rawValue
            return AnswerTimeLimit(rawValue: raw) ?? .unlimited
        }
        set {
            defaults.set(newValue.rawValue, forKey: Key.answerTimeLimit)
        }
    }
    
    // MARK: - 다크모드 설정
    static var isDarkMode: Bool {
        get {
            defaults.bool(forKey: Key.isDarkMode)
        }
        set {
            defaults.set(newValue, forKey: Key.isDarkMode)
        }
    }
    
    // MARK: - 항상 답 보기
    static var alwaysShowSampleAnswer: Bool {
        get {
            defaults.bool(forKey: Key.alwaysShowSampleAnswer)
        }
        set {
            defaults.set(newValue, forKey: Key.alwaysShowSampleAnswer)
        }
    }
    
    // MARK: - 온보딩 여부
    static var isOnboardingCompleted: Bool {
        get { defaults.bool(forKey: Key.isOnboardingCompleted) }
        set { defaults.set(newValue, forKey: Key.isOnboardingCompleted) }
    }
    
    // MARK: - 학습 통계
    
    /// 사용자가 답변한 총 질문 수
    static var totalAnsweredCount: Int {
        get { defaults.integer(forKey: StatKey.totalAnsweredCount) }
        set { defaults.set(newValue, forKey: StatKey.totalAnsweredCount) }
    }
    
    /// 마지막 학습 날짜
    static var lastStudyDate: Date? {
        get { defaults.object(forKey: StatKey.lastStudyDate) as? Date }
        set { defaults.set(newValue, forKey: StatKey.lastStudyDate) }
    }
    
    /// 카테고리별 학습 횟수
    static var categoryAnswerCount: [String: Int] {
        get {
            return defaults.dictionary(forKey: StatKey.categoryAnswerCount) as? [String: Int] ?? [:]
        }
        set {
            defaults.set(newValue, forKey: StatKey.categoryAnswerCount)
        }
    }
    
    /// 평균 키워드 일치율 (0.0 ~ 1.0)
    static var averageKeywordMatch: Double {
        get { defaults.double(forKey: StatKey.averageKeywordMatch) }
        set { defaults.set(newValue, forKey: StatKey.averageKeywordMatch) }
    }
    
    // 고유하게 답변한 질문 ID 집합
    static var uniqueAnsweredIDs: Set<UUID> {
        get {
            guard let saved = defaults.array(forKey: StatKey.uniqueAnsweredIDs) as? [String] else { return [] }
            return Set(saved.compactMap{ UUID(uuidString: $0)})
        }
        set {
            let stringArray = newValue.map { $0.uuidString }
            defaults.set(stringArray, forKey: StatKey.uniqueAnsweredIDs)
        }
    }
    
    // 중복 여부와 관계없이 답변 등록
    static func registerAnsweredQuestions(_ id: UUID) {
        var set = uniqueAnsweredIDs
        set.insert(id)
        uniqueAnsweredIDs = set
        
        totalAnsweredCount += 1
    }
}

//extension UserDefaultManager {
//    #if DEBUG
//    static func resetAllStatistics() {
//        defaults.removeObject(forKey: StatKey.totalAnsweredCount)
//        defaults.removeObject(forKey: StatKey.lastStudyDate)
//        defaults.removeObject(forKey: StatKey.categoryAnswerCount)
//        defaults.removeObject(forKey: StatKey.averageKeywordMatch)
//        defaults.removeObject(forKey: StatKey.uniqueAnsweredIDs)
//    }
//    #endif
//}
