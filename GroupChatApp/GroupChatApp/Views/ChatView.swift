//
//  ChatView.swift
//  GroupChatApp
//
//  Created by Lucy Rez on 03.06.2025.
//

import SwiftUI

struct ChatView: View {
    let chat: Chat
    @StateObject private var firebaseService = FirebaseService.shared
    @State private var messages: [Message] = []
    @State private var newMessage = ""
    
    var body: some View {
        VStack {
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 10) {
                        ForEach(messages) { message in
                            MessageView(message: message, isCurrentUser: message.senderId == firebaseService.currentUser?.id)
                                .id(message.id)
                        }
                    }
                    .padding()
                }
                .onChange(of: messages) { newMessages in
                    if let lastMessage = newMessages.last {
                        withAnimation {
                            proxy.scrollTo(lastMessage.id, anchor: .bottom)
                        }
                    }
                }
            }
            
            HStack {
                TextField("Message", text: $newMessage)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button(action: {
                    Task {
                        do {
                            try await firebaseService.sendMessage(chatId: chat.id!, content: newMessage)
                            newMessage = ""
                        } catch {
                            print("Error sending message: \(error.localizedDescription)")
                        }
                    }
                }) {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.blue)
                }
                .disabled(newMessage.isEmpty)
            }
            .padding()
        }
        .navigationTitle(chat.name)
        .onAppear {
            print("ChatView appeared, chatId: \(chat.id ?? "nil")")
            firebaseService.observeMessages(chatId: chat.id!) { updatedMessages in
                print("Received \(updatedMessages.count) messages")
                self.messages = updatedMessages
            }
        }
    }
}

struct MessageView: View {
    let message: Message
    let isCurrentUser: Bool
    
    var body: some View {
        HStack {
            if isCurrentUser { Spacer() }
            
            VStack(alignment: isCurrentUser ? .trailing : .leading) {
                Text(message.senderName)
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Text(message.content)
                    .padding(10)
                    .background(isCurrentUser ? Color.blue : Color.gray.opacity(0.2))
                    .foregroundColor(isCurrentUser ? .white : .primary)
                    .cornerRadius(10)
            }
            
            if !isCurrentUser { Spacer() }
        }
    }
}
