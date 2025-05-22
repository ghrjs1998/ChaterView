//
//  AppState.swift
//  ChaterView
//
//  Created by 박호건 on 4/28/25.
//

import Foundation

final class AppState: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var isInitialized: Bool = false
    @Published var isDarkMode: Bool = UserDefaultManager.isDarkMode
    @Published var userName: String? = UserDefaultManager.userName
    
    func updateDarkMode(_ isOn: Bool) {
        isDarkMode = isOn
        UserDefaultManager.isDarkMode = isOn
    }
}
