////
////  StudyStatisticsSettingView.swift
////  ChaterView
////
////  Created by 박호건 on 2025/04/24.
////
//
//import SwiftUI
//
//struct StudyStatisticsSettingView: View {
//    @Environment(\.dismiss) private var dismiss
//    
//    var body: some View {
//        VStack {
//            // 커스텀 네비게이션 바
//            ZStack {
//                Text("학습 통계")
//                    .font(.title3)
//                    .bold()
//                    .frame(maxWidth: .infinity, alignment: .center)
//                
//                HStack {
//                    Button {
//                        dismiss()
//                    } label: {
//                        Image(systemName: "chevron.left")
//                            .font(.title3)
//                            .foregroundColor(.blue)
//                    }
//                    Spacer()
//                }
//            }
//            .padding(.horizontal)
//            .padding(.top, 16)
//            .padding(.bottom, 12)
//            
//            List {
//                Section(header: Text("기본 통계")) {
//                    StatisticRow(title: "총 답변한 질문 수", value: "\(UserDefaultManager.totalAnsweredCount)개")
//                    
//                    let avgMatch = Int(UserDefaultManager.averageKeywordMatch * 100)
//                    StatisticRow(title: "평균 키워드 일치율", value: "\(avgMatch)%")
//                    
//                    let date = UserDefaultManager.lastStudyDate?.formatted(.dateTime.year().month().day()) ?? "기록 없음"
//                    StatisticRow(title: "마지막 학습일", value: date)
//                }
//                
//                Section(header: Text("카테고리별 학습 횟수")) {
//                    ForEach(UserDefaultManager.categoryAnswerCount.sorted(by: { $0.key < $1.key }), id: \.key) { key, value in
//                        StatisticRow(title: key.capitalized, value: "\(value)회")
//                    }
//                }
//            }
//            .listStyle(.insetGrouped)
//        }
//        .navigationBarBackButtonHidden()
//    }
//}
//
//struct StatisticRow: View {
//    let title: String
//    let value: String
//    
//    var body: some View {
//        HStack {
//            Text(title)
//            Spacer()
//            Text(value)
//                .foregroundColor(.secondary)
//        }
//    }
//}
//
//// MARK: - Preview
//#Preview {
//    StudyStatisticsSettingView()
//}

import SwiftUI

struct StudyStatisticsSettingView: View {
    @Environment(\.dismiss) private var dismiss

    // MARK: - Computed Properties
    private var totalAnswered: Int {
        UserDefaultManager.totalAnsweredCount
    }

    private var averageMatch: Int {
        Int(UserDefaultManager.averageKeywordMatch * 100)
    }

    private var lastDateString: String {
        if let date = UserDefaultManager.lastStudyDate {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "ko_KR")
            formatter.dateFormat = "yyyy년 M월 d일"
            return formatter.string(from: date)
        } else {
            return "기록 없음"
        }
    }

    private var categoryStats: [(title: String, count: Int)] {
        UserDefaultManager.categoryAnswerCount
            .sorted { $0.key < $1.key }
            .map { (title: $0.key.capitalized, count: $0.value) }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // 네비게이션 바
                ZStack {
                    Text("학습 통계")
                        .font(.titleMedium)
                        .foregroundColor(.textPrimary)
                        .frame(maxWidth: .infinity, alignment: .center)

                    HStack {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "chevron.left")
                                .font(.title3)
                                .foregroundColor(.primaryBlue)
                        }
                        Spacer()
                    }
                }
                .padding(.horizontal)
                .padding(.top, 16)
                .padding(.bottom, 12)
                
                // 0건 처리
                if totalAnswered == 0 {
                    VStack(spacing: 12) {
                        Text("아직 학습 기록이 없어요!")
                            .font(.bodyMedium)
                            .foregroundColor(.textSecondary)
                            .padding(.top, 20)
                    }
                    .frame(maxWidth: .infinity)
                } else {
                    
                    // 통계 카드 요약
                    HStack(spacing: 12) {
                        StatisticSummaryCard(title: "총 답변 수", value: "\(totalAnswered)")
                        StatisticSummaryCard(title: "일치율", value: "\(averageMatch)%")
                        StatisticSummaryCard(title: "최근 학습", value: lastDateString)
                    }
                    .padding(.horizontal)
                    
                    // 카테고리별 통계
                    VStack(alignment: .leading, spacing: 12) {
                        Text("📂 카테고리별 학습 횟수")
                            .font(.headline)
                            .foregroundColor(.textPrimary)
                            .padding(.horizontal)
                        
                        ForEach(categoryStats, id: \.title) { stat in
                            HStack {
                                Text(stat.title.capitalized)
                                    .font(.bodyMedium)
                                    .foregroundColor(.textPrimary)
                                Spacer()
                                Text("\(stat.count)회")
                                    .foregroundColor(.textSecondary)
                            }
                            .padding()
                            .background(Color.surface)
                            .cornerRadius(10)
                            .padding(.horizontal)
                        }
                    }
                }
                Spacer(minLength: 50)
            }
            .padding(.top)
        }
        .background(Color.background)
        .navigationBarBackButtonHidden()
    }
}

struct StatisticSummaryCard: View {
    let title: String
    let value: String

    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.titleLarge)
                .foregroundColor(.primaryBlue)
            Text(title)
                .font(.caption)
                .foregroundColor(.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.surface)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

#Preview {
    StudyStatisticsSettingView()
}
