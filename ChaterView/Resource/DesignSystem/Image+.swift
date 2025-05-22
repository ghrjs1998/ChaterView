//
//  Image+.swift
//  ChaterView
//
//  Created by 박호건 on 4/29/25.
//

import SwiftUI

public enum DSImage: String {
    
    case onboarding_home
    case onboarding_interview
    case onboarding_settings
    case bronze_medal
    case silver_medal
    case gold_medal
    case google
    case kakao
    case naver
    case apple
    
    var toName: String {
        return self.rawValue
    }
}

extension DSImage {
    func toImage() -> Image {
        if let uiImage = UIImage(named: self.toName) {
            return Image(uiImage: uiImage)
        } else {
            print("❌ Failed to load image: \(self.rawValue)")
            fatalError("Missing image asset: \(self.rawValue)")
        }
    }
}


