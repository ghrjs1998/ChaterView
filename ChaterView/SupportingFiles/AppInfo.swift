//
//  AppInfo.swift
//  ChaterView
//
//  Created by 박호건 on 4/14/25.
//

import Foundation

struct AppInfo {
    static var version: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
    }

    static var build: String {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
    }
}
