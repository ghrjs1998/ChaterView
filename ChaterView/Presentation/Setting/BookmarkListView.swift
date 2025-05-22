//
//  BookmarkListView.swift
//  ChaterView
//
//  Created by 박호건 on 4/21/25.
//

import SwiftUI

struct BookmarkListView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var bookmarkedQuestions: [InterviewQuestion] = []
    
    @State private var showAlert: Bool = false
    @State private var selectedQuestionID: UUID?

    var body: some View {
            VStack {
                ZStack {
                    Text("북마크한 질문")
                        .font(.titleMedium)
                        .foregroundColor(.textPrimary)
                        .frame(maxWidth: .infinity, alignment: .center)

                    HStack {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "chevron.left")
                                .font(.title3)
                                .foregroundColor(.blue)
                        }
                        Spacer()
                    }
                }
                .padding(.horizontal)
                .padding(.top, 16)
                .padding(.bottom, 12)

                if bookmarkedQuestions.isEmpty {
                    Spacer()
                    Text("북마크된 질문이 없습니다.")
                        .foregroundColor(.secondary)
                    Spacer()
                } else {
                    List {
                        ForEach(bookmarkedQuestions) { question in
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text(question.question)
                                        .font(.body)
                                        .bold()
                                    Spacer()
                                    Button {
                                        selectedQuestionID = question.id
                                        showAlert = true
                                    } label: {
                                        Image(systemName: "bookmark.fill")
                                            .foregroundColor(.yellow)
                                            .imageScale(.large)
                                    }
                                    .buttonStyle(.plain)
                                }

                                Text("카테고리: \(question.category.displayName)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)

                                Text("예시 답변: \(question.sampleAnswer)")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .lineLimit(3)
                            }
                            .padding(.vertical, 6)
                            .swipeActions {
                                Button(role: .destructive) {
                                    selectedQuestionID = question.id
                                    showAlert = true
                                } label: {
                                    Text("삭제")
                                }
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .onAppear(perform: loadBookmarkedQuestions)
            .alert("이 질문의 북마크를 해제할까요?", isPresented: $showAlert) {
                Button("예", role: .destructive) {
                    if let id = selectedQuestionID {
                        BookmarkManager.shared.toggle(id)
                        loadBookmarkedQuestions()
                    }
                }
                Button("취소", role: .cancel) {}
            }
            .navigationBarBackButtonHidden()
        }

        private func deleteBookmark(at offsets: IndexSet) {
            for index in offsets {
                let question = bookmarkedQuestions[index]
                BookmarkManager.shared.toggle(question.id)
            }
            loadBookmarkedQuestions()
        }

        private func loadBookmarkedQuestions() {
            let bookmarkedIDs = BookmarkManager.shared.bookmarkedIDs
            var result: [InterviewQuestion] = []

            for category in CategoryType.allCases {
                if let questions = InterviewQuestionLoader.load(for: category) {
                    result += questions.filter { bookmarkedIDs.contains($0.id) }
                }
            }

            bookmarkedQuestions = result
        }
}

// MARK: - Preview
#Preview {
    BookmarkListViewPreviewWrapper()
}

private struct BookmarkListViewPreviewWrapper: View {
    init() {
        let sampleID = UUID(uuidString: "44444444-4444-4444-4444-000000000001")!
        BookmarkManager.shared.forceSet([sampleID])
    }

    var body: some View {
        BookmarkListView()
    }
}
