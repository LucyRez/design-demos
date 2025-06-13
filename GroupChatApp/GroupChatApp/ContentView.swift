//
//  ContentView.swift
//  GroupChatApp
//
//  Created by Lucy Rez on 03.06.2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var firebaseService = FirebaseService.shared
    @State private var isShowingAuth = false
    
    var body: some View {
        Group {
            if firebaseService.currentUser != nil {
                ChatListView()
            } else {
                AuthView()
            }
        }
    }
} 

#Preview {
    ContentView()
}
