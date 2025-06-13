//
//  GroupChatAppApp.swift
//  GroupChatApp
//
//  Created by Lucy Rez on 03.06.2025.
//

import SwiftUI
import FirebaseCore

@main
struct ChatAppApp: App {
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
} 
