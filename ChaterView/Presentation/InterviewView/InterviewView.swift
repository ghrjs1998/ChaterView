//
//  InterviewView.swift
//  ChaterView
//
//  Created by 박호건 on 4/9/25.
//

import SwiftUI

struct InterviewView: View {
    private let category: CategoryType
    @StateObject private var viewModel: InterviewViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var lastMessageID: UUID? = nil
    
    init(viewModel: InterviewViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.category = viewModel.category
    }
    
    var body: some View {
        VStack {
            Text("\(category.displayName) 면접")
                .font(.titleLarge)
                .foregroundColor(.textPrimary)
                .padding(.top, 20)
            
            if let remaining = viewModel.remainingTime {
                Text("⏳ \(remaining)초 남음")
                    .font(.caption)
                    .foregroundColor(remaining <= 10 ? .red : .orange)
                    .fontWeight(remaining <= 5 ? .bold : .regular)
                    .transition(.opacity)
                    .animation(.easeInOut, value: remaining)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.trailing, 16)
            }
            
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 12) {
                        ForEach(viewModel.messages) { message in
                            HStack {
                                if message.isQuestion || message.isFeedback {
                                    ChatBubble(text: message.text, isFromUser: false,
                                               questionID: message.questionID)
                                    Spacer()
                                } else {
                                    Spacer()
                                    ChatBubble(text: message.text, isFromUser: true)
                                }
                            }
                            .id(message.id)
                        }
                    }
                    .padding(.horizontal)
                }
                .background(Color.background)
                .onChange(of: viewModel.messages.count) { _ in
                    if let last = viewModel.messages.last {
                        lastMessageID = last.id
                    }
                }
                .onChange(of: lastMessageID) { id in
                    if let id = id {
                        DispatchQueue.main.async {
                            withAnimation(.easeOut(duration: 0.25)) {
                                proxy.scrollTo(id, anchor: .bottom)
                            }
                        }
                    }
                }
            }
            
            Divider()
            
            if !UserDefaultManager.alwaysShowSampleAnswer {
                HStack {
                    TextField("답변을 입력하세요.", text: $viewModel.userInput)
                        .font(.bodyMedium)
                        .padding(12)
                        .background(Color.surface)
                    //                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    //                    .frame(minHeight: 44)
                    
                    Button {
                        viewModel.submitAnswer()
                    } label: {
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.system(size: 32))
                            .foregroundColor(viewModel.userInput.trimmingCharacters(in: .whitespaces).isEmpty ? .gray : .primaryBlue)
                    }
                    .disabled(viewModel.userInput.trimmingCharacters(in: .whitespaces).isEmpty)
                }
                .padding()
                .background(Color.background)
            }
            
            if viewModel.isNextButtonVisible {
                Button {
                    viewModel.goToNextQuestion()
                } label: {
                    Text("다음 질문")
                        .font(.bodyLarge)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.primaryBlue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .padding(.horizontal)
                }
            }
        }
        .background(Color.background)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                        Text("홈")
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    InterviewView(viewModel: InterviewViewModel(category: .ios))
}
