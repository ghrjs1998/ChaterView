//
//  HomeViewModel.swift
//  ChaterView
//
//  Created by 박호건 on 4/9/25.
//

import Foundation

final class HomeViewModel: ObservableObject {
    @Published var selectedCategory: CategoryType?
    @Published var navigateToInterView = false
    
    func selectCategory(_ category: CategoryType) {
        selectedCategory = category
        navigateToInterView = true
    }
}
