//
//  test_localizeApp.swift
//  test-localize
//
//  Created by brfsu on 22.05.2024.
//

import SwiftUI

@main
struct test_localizeApp: App {
    var body: some Scene {
        WindowGroup {
            AboutView() // .environment(\.locale, .init(identifier: "ru")) // en
        }
    }
}
