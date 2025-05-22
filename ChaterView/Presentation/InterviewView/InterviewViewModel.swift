//
//  InterviewViewModel.swift
//  ChaterView
//
//  Created by 박호건 on 4/9/25.
//

import Foundation
import Combine

final class InterviewViewModel: ObservableObject {
    // Published properties
    @Published var currentQuestionIndex: Int = 0
    @Published var messages: [InterviewMessage] = []
    @Published var userInput: String = ""
    @Published var isNextButtonVisible: Bool = false
    @Published var remainingTime: Int? = nil
    
    private(set) var questions: [InterviewQuestion] = []
    private var timer: AnyCancellable?
    
    // 의존성
    let category: CategoryType
    let feedbackTone: FeedbackTone
    let answerTimeLimit: AnswerTimeLimit
    
    // MARK: - Init
    init(category: CategoryType) {
        self.category = category
        self.feedbackTone = UserDefaultManager.feedbackTone
        self.answerTimeLimit = UserDefaultManager.answerTimeLimit
        loadQuestions(for: category)
    }
    
    init(category: CategoryType, questions: [InterviewQuestion]) {
        self.category = category
        self.questions = questions
        self.feedbackTone = UserDefaultManager.feedbackTone
        self.answerTimeLimit = UserDefaultManager.answerTimeLimit
        appendQuestion()
    }
    
    var currentQuestionID: UUID? {
        guard currentQuestionIndex < questions.count else { return nil }
        return questions[currentQuestionIndex].id
    }
    
    // MARK: - 질문 로드 및 표시
    private func addMessage(_ text: String, type: InterviewMessage.MessageType) {
        let id = currentQuestionID
        messages.append(InterviewMessage(id: UUID(), text: text, type: type, questionID: id))
    }
    
    func loadQuestions(for category: CategoryType) {
        guard let loaded = InterviewQuestionLoader.load(for: category) else {
            print("❌ \(category.rawValue) 질문 로딩 실패")
            return
        }
        self.questions = loaded.shuffled()
        
        appendQuestion()
    }
    
    func appendQuestion() {
        guard currentQuestionIndex < questions.count else { return }
        let q = questions[currentQuestionIndex]
        addMessage(q.question, type: .question)
        
        if UserDefaultManager.alwaysShowSampleAnswer {
            addMessage(q.sampleAnswer, type: .sampleAnswer)
            isNextButtonVisible = true
        } else if let seconds = answerTimeLimit.timeInSeconds {
            startTimer(seconds: seconds)
        }
    }
    
    // MARK: - 사용자 응답 제출
    func submitAnswer() {
        guard !userInput.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        
        stopTimer()
        
        let answerText = userInput
        addMessage(answerText, type: .answer)
        userInput = ""
        
        guard currentQuestionIndex < questions.count else { return }
        let currentQ = questions[currentQuestionIndex]
        
        let feedback = InterviewFeedbackGenerator.generate(for: answerText, question: currentQ, tone: feedbackTone)
        addMessage(feedback, type: .feedback)
        evaluateAnswer(answerText, for: currentQ)
        
        updateStatistics(answer: answerText, for: currentQ)
    }
    
    private func updateStatistics(answer: String, for question: InterviewQuestion) {
        // 중복 제거된 질문 ID + 총 답변 수 업데이트
        UserDefaultManager.registerAnsweredQuestions(question.id)
        
        // 카테고리별 학습 횟수 업데이트
        var perCategory = UserDefaultManager.categoryAnswerCount
        let key = question.category.rawValue
        perCategory[key, default: 0] += 1
        UserDefaultManager.categoryAnswerCount = perCategory

        // 마지막 학습 날짜
        UserDefaultManager.lastStudyDate = Date()
        
        // 평균 키워드 일치율 계산
        let currentMatchCount = question.keywords.filter { answer.localizedCaseInsensitiveContains($0) }.count
        let keywordRatio = Double(currentMatchCount) / Double(max(question.keywords.count, 1))

        let previousAvg = UserDefaultManager.averageKeywordMatch
        let totalCount = UserDefaultManager.totalAnsweredCount
        let newAverage = ((previousAvg * Double(totalCount - 1)) + keywordRatio) / Double(totalCount)
        
        UserDefaultManager.averageKeywordMatch = newAverage
    }
    
    private func evaluateAnswer(_ answer: String, for question: InterviewQuestion) {
        guard !UserDefaultManager.alwaysShowSampleAnswer else {
            isNextButtonVisible = true
            return
        }
        
        let matched = question.keywords.filter { answer.localizedCaseInsensitiveContains($0) }
        let total = question.keywords.count
        guard total > 0 else { return }
        
        let ratio = Double(matched.count) / Double(total)
        
        if ratio >= 0.75 && matched.count >= 2 {
            addMessage(question.sampleAnswer, type: .sampleAnswer)
            isNextButtonVisible = true
        }
    }
    
    // MARK: - 다음 질문
    func goToNextQuestion() {
        isNextButtonVisible = false
        currentQuestionIndex += 1
        appendQuestion()
    }
    
    // MARK: - 타이머 관리
    private func startTimer(seconds: Int) {
        remainingTime = seconds
        
        timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self else { return }
                if let time = self.remainingTime, time > 0 {
                    self.remainingTime = time - 1
                } else {
                    self.stopTimer()
                    self.submitAnswer()
                }
            }
    }
    
    private func stopTimer() {
        timer?.cancel()
        timer = nil
        remainingTime = nil
    }
}

//enum InterviewMessage: Identifiable {
//    case question(String)
//    case answer(String)
//    case feedback(String)
//    case sampleAnswer(String)
//    
//    var id: UUID {
//        UUID()
//    }
//    
//    var text: String {
//        switch self {
//        case .question(let q): return q
//        case .answer(let a): return a
//        case .feedback(let f): return f
//        case .sampleAnswer(let s): return s
//        }
//    }
//    
//    var isQuestion: Bool {
//        if case .question = self { return true }
//        return false
//    }
//    
//    var isFeedback: Bool {
//        if case .feedback = self { return true }
//        return false
//    }
//    
//    var isSample: Bool {
//        if case .sampleAnswer = self { return true }
//        return false
//    }
//}

struct InterviewMessage: Identifiable, Equatable {
    enum MessageType {
        case question
        case answer
        case feedback
        case sampleAnswer
    }
    
    let id: UUID
    let text: String
    let type: MessageType
    let questionID: UUID?
    
    var isQuestion: Bool { type == .question }
    var isFeedback: Bool { type == .feedback }
    var isSample: Bool { type == .sampleAnswer }
    var isFromUser: Bool { type == .answer }
}
