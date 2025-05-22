////
////  ChatBubble.swift
////  ChaterView
////
////  Created by 박호건 on 4/9/25.
////
//
//import SwiftUI
//
//struct ChatBubble: View {
//    let text: String
//    let isFromUser: Bool
//    var questionID: UUID? = nil
//
//    @Environment(\.colorScheme) private var colorScheme
//    @ObservedObject private var bookmarkManager: BookmarkManager = .shared
//
//    var body: some View {
//        HStack(alignment: .top, spacing: 8) {
//            if !isFromUser {
//                VStack(alignment: .leading, spacing: 4) {
//                    HStack(alignment: .top) {
//                        Text(text)
//                            .foregroundColor(colorScheme == .dark ? .white : .black)
//                        Spacer()
//                        if let id = questionID {
//                            Button {
//                                bookmarkManager.toggle(id)
//                            } label: {
//                                Image(systemName: bookmarkManager.isBookmarked(id) ? "bookmark.fill" : "bookmark")
//                                    .font(.system(size: 24))
//                                    .foregroundColor(.yellow)
//                            }
//                            .buttonStyle(.plain)
//                        }
//                    }
//                    .padding()
//                    .background(colorScheme == .dark ? Color.gray.opacity(0.4) : Color.gray.opacity(0.2))
//                    .cornerRadius(12)
//                }
//                Spacer()
//            } else {
//                Spacer()
//                Text(text)
//                    .padding()
//                    .foregroundColor(.white)
//                    .background(Color.blue)
//                    .cornerRadius(12)
//            }
//        }
//        .frame(maxWidth: 280, alignment: isFromUser ? .trailing : .leading)
//        .padding(isFromUser ? .leading : .trailing, 40)
//    }
//}
//#Preview {
//    ChatBubble(text: "Swift의 struct와 class 차이는?", isFromUser: false, questionID: UUID())
//}

//
//  ChatBubble.swift
//  ChaterView
//
//  Created by 박호건 on 4/9/25.
//

import SwiftUI

struct ChatBubble: View {
    let text: String
    let isFromUser: Bool
    var questionID: UUID? = nil

    @Environment(\.colorScheme) private var colorScheme
    @ObservedObject private var bookmarkManager: BookmarkManager = .shared

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            if !isFromUser {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(alignment: .top) {
                        Text(text)
                            .font(.bodyLarge)
                            .foregroundColor(.textPrimary)
                        
                        Spacer()
                        
                        if let id = questionID {
                            Button {
                                bookmarkManager.toggle(id)
                            } label: {
                                Image(systemName: bookmarkManager.isBookmarked(id) ? "bookmark.fill" : "bookmark")
                                    .font(.system(size: 20))
                                    .foregroundColor(.yellow)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding()
                    .background(Color.surface)
                    .cornerRadius(16)
                    .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                }
                Spacer()
            } else {
                Spacer()
                Text(text)
                    .font(.bodyLarge)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.primaryBlue)
                    .cornerRadius(16)
                    .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
            }
        }
        .frame(maxWidth: 280, alignment: isFromUser ? .trailing : .leading)
        .padding(isFromUser ? .leading : .trailing, 40)
    }
}

#Preview {
    ChatBubble(text: "Swift의 struct와 class 차이는?", isFromUser: false, questionID: UUID())
}
