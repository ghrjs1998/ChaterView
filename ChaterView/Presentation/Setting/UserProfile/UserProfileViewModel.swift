////
////  UserProfileViewModel.swift
////  ChaterView
////
////  Created by 박호건 on 4/30/25.
////
//
//import Foundation
//import FirebaseAuth
//
//final class UserProfileViewModel: ObservableObject {
//    @Published var profile: UserProfile?
//
//    init() {
//        fetchProfile()
//    }
//
//    func fetchProfile() {
//        guard let user = Auth.auth().currentUser else { return }
//        
//        let badge = BadgeLevel.calculateBadge(
//            uniqueCount: UserDefaultManager.uniqueAnsweredIDs.count,
//            match: UserDefaultManager.averageKeywordMatch
//        )
//        
//        profile = UserProfile(
//            name: user.displayName ?? "이름 없음",
//            badge: badge
//        )
//    }
//}
//
//struct UserProfile {
//    let name: String
//    let badge: BadgeLevel
//}
