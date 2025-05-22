////
////  UserProfileCard.swift
////  ChaterView
////
////  Created by 박호건 on 4/30/25.
////
//
//import SwiftUI
//
//struct UserProfileCard: View {
//    @StateObject private var viewModel = UserProfileViewModel()
//
//    var body: some View {
//        if let profile = viewModel.profile {
//            HStack(spacing: 16) {
//                profile.badge.image
//                    .resizable()
//                    .frame(width: 48, height: 48)
//
//                Text(profile.name)
//                    .font(.title3)
//                    .fontWeight(.semibold)
//
//                Spacer()
//            }
//            .padding()
//            .background(Color.surface)
//            .cornerRadius(12)
//        }
//    }
//}

import SwiftUI

struct UserProfileCard: View {
    @EnvironmentObject private var appState: AppState
    let badge: BadgeLevel

    var body: some View {
        HStack(spacing: 16) {
            badgeImage
                .resizable()
                .scaledToFit()
                .frame(width: 48, height: 48)
                .clipShape(Circle())
                .background(
                    Circle()
                        .fill(Color.surface)
                        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                )

            VStack(alignment: .leading, spacing: 4) {
                Text(appState.userName ?? "사용자")
                    .font(.titleSmall)
                    .foregroundColor(.textPrimary)

                ProgressView(value: badgeProgress)
                    .progressViewStyle(LinearProgressViewStyle(tint: badge.color))
                    .frame(maxWidth: 180)

                Text("다음 등급까지 \(remainingText)")
                    .font(.caption)
                    .foregroundColor(.textSecondary)
            }

            Spacer()
        }
        .padding()
        .background(Color.surface)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }

    private var badgeImage: Image {
        switch badge {
        case .beginner:
            return DSImage.bronze_medal.toImage()
        case .intermediate:
            return DSImage.silver_medal.toImage()
        case .expert:
            return DSImage.gold_medal.toImage()
        }
    }

    private var badgeProgress: Double {
        let count = UserDefaultManager.uniqueAnsweredIDs.count
        switch badge {
        case .beginner:
            return min(Double(count) / 50.0, 1.0)
        case .intermediate:
            return min(Double(count - 50) / 100.0, 1.0)
        case .expert:
            return 1.0
        }
    }

    private var remainingText: String {
        let count = UserDefaultManager.uniqueAnsweredIDs.count
        switch badge {
        case .beginner:
            return "\(max(0, 50 - count))문항"
        case .intermediate:
            return "\(max(0, 150 - count))문항"
        case .expert:
            return "축하합니다!"
        }
    }
}
