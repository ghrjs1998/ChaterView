//
//  BookmarkManager.swift
//  ChaterView
//
//  Created by 박호건 on 4/21/25.
//


import Foundation

final class BookmarkManager: ObservableObject {
    static let shared = BookmarkManager()

    @Published private(set) var bookmarkedIDs: Set<UUID> = []

    private let key = "bookmarkedQuestionIDs"
    private let defaults = UserDefaults.standard

    private init() {
        bookmarkedIDs = load()
    }

    func isBookmarked(_ id: UUID) -> Bool {
        bookmarkedIDs.contains(id)
    }
    
    func forceSet(_ ids: Set<UUID>) {
        bookmarkedIDs = ids
        save()
    }

    func toggle(_ id: UUID) {
        if bookmarkedIDs.contains(id) {
            bookmarkedIDs.remove(id)
        } else {
            bookmarkedIDs.insert(id)
        }
        save()
    }

    private func load() -> Set<UUID> {
        guard let saved = defaults.array(forKey: key) as? [String] else { return [] }
        return Set(saved.compactMap { UUID(uuidString: $0) })
    }

    private func save() {
        let stringArray = bookmarkedIDs.map { $0.uuidString }
        defaults.set(stringArray, forKey: key)
    }
}
