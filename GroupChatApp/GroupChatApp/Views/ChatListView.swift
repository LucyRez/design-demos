//
//  ChatListView.swift
//  GroupChatApp
//
//  Created by Lucy Rez on 03.06.2025.
//

import SwiftUI

struct ChatListView: View {
    @StateObject private var firebaseService = FirebaseService.shared
    @State private var chats: [Chat] = []
    @State private var isShowingNewChat = false
    @State private var isShowingJoinChat = false
    @State private var newChatName = ""
    @State private var joinCode = ""
    
    var body: some View {
        NavigationView {
            List(chats) { chat in
                NavigationLink(destination: ChatView(chat: chat)) {
                    VStack(alignment: .leading) {
                        Text(chat.name)
                            .font(.headline)
                        Text("Join Code: \(chat.joinCode)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
            }
            .navigationTitle("Chats")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button("New Chat") {
                            isShowingNewChat = true
                        }
                        Button("Join Chat") {
                            isShowingJoinChat = true
                        }
                        Button("Sign Out") {
                            try? firebaseService.signOut()
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
            .onAppear {
                firebaseService.observeChats { updatedChats in
                    self.chats = updatedChats
                }
            }
            .alert("New Chat", isPresented: $isShowingNewChat) {
                TextField("Chat Name", text: $newChatName)
                Button("Cancel", role: .cancel) {}
                Button("Create") {
                    Task {
                        do {
                            _ = try await firebaseService.createChat(name: newChatName)
                            newChatName = ""
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
            }
            .alert("Join Chat", isPresented: $isShowingJoinChat) {
                TextField("Join Code", text: $joinCode)
                Button("Cancel", role: .cancel) {}
                Button("Join") {
                    Task {
                        do {
                            _ = try await firebaseService.joinChat(joinCode: joinCode)
                            joinCode = ""
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
            }
        }
    }
} 
