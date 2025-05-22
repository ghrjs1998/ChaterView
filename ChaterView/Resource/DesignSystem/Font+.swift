//
//  Font+.swift
//  ChaterView
//
//  Created by 박호건 on 2025/04/28.
//

import SwiftUI

extension Font {
    
    // Title
    static let titleLarge = Font.system(size: 28, weight: .bold)
    static let titleMedium = Font.system(size: 22, weight: .semibold)
    static let titleSmall = Font.system(size: 18, weight: .semibold)
    
    // Body
    static let bodyLarge = Font.system(size: 17, weight: .regular)
    static let bodyMedium = Font.system(size: 15, weight: .regular)
    static let bodySmall = Font.system(size: 13, weight: .regular)
    
    // Caption
    static let caption = Font.system(size: 12, weight: .light)
    
    // Custom Example (선택)
    static let logoFont = Font.system(size: 32, weight: .black, design: .rounded)
}
