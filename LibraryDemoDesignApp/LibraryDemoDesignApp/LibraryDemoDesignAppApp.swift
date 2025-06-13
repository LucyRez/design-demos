//
//  LibraryDemoDesignAppApp.swift
//  LibraryDemoDesignApp
//
//  Created by Lucy Rez on 29.01.2025.
//

import SwiftUI

@main
struct LibraryDemoDesignAppApp: App {
    @State var isOnboardingFinished = false
    var body: some Scene {
        WindowGroup {
            if (isOnboardingFinished) {
                CardsView()
            } else {
                OnboardingView(isOnboardingFinished: $isOnboardingFinished)
            }
            
        }
    }
}
