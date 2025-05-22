//
//  InterviewQuestionLoader.swift
//  ChaterView
//
//  Created by 박호건 on 4/11/25.
//

import Foundation

enum InterviewQuestionLoader {
    static func load(for category: CategoryType) -> [InterviewQuestion]? {
        let fileName = "\(category.rawValue)_questions"
        
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            print("❌ \(fileName).json 파일을 찾을 수 없습니다.")
            return nil
        }
        
        do {
            let data = try Data(contentsOf: url)
            let questions = try JSONDecoder().decode([InterviewQuestion].self, from: data)
            return questions
        } catch {
            print("❌ \(fileName).json 디코딩 실패: \(error)")
            return nil
        }
    }
}
