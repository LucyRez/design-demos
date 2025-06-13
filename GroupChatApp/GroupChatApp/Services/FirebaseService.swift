//
//  FirebaseService.swift
//  GroupChatApp
//
//  Created by Lucy Rez on 03.06.2025.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore

class FirebaseService: ObservableObject {
    static let shared = FirebaseService()
    private let auth = Auth.auth()
    private let db = Firestore.firestore()
    
    @Published var currentUser: User?
    
    // MARK: - Authentication
    
    func signUp(email: String, password: String, username: String) async throws {
        let result = try await auth.createUser(withEmail: email, password: password)
        let user = User(id: result.user.uid, email: email, username: username)
        try await db.collection("users").document(result.user.uid).setData(from: user)
        await MainActor.run {
            self.currentUser = user
        }
    }
    
    func signIn(email: String, password: String) async throws {
        let result = try await auth.signIn(withEmail: email, password: password)
        let document = try await db.collection("users").document(result.user.uid).getDocument()
        let user = try document.data(as: User.self)
        await MainActor.run {
            self.currentUser = user
        }
    }
    
    func signOut() throws {
        try auth.signOut()
        self.currentUser = nil
    }
    
    // MARK: - Chat Operations
    
    func createChat(name: String) async throws -> Chat {
        guard let userId = currentUser?.id else { throw NSError(domain: "", code: -1) }
        
        let joinCode = String(Int.random(in: 100000...999999))
        let chat = Chat(name: name, joinCode: joinCode, createdAt: Date(), members: [userId])
        
        let document = try await db.collection("chats").addDocument(from: chat)
        return try await document.getDocument().data(as: Chat.self)
    }
    
    func joinChat(joinCode: String) async throws -> Chat {
        guard let userId = currentUser?.id else { throw NSError(domain: "", code: -1) }
        
        let snapshot = try await db.collection("chats")
            .whereField("joinCode", isEqualTo: joinCode)
            .getDocuments()
        
        guard let document = snapshot.documents.first else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Chat not found"])
        }
        
        var chat = try document.data(as: Chat.self)
        chat.members.append(userId)
        try await document.reference.setData(from: chat)
        
        return chat
    }
    
    func sendMessage(chatId: String, content: String) async throws {
        guard let user = currentUser else {
            print("Error: No current user")
            throw NSError(domain: "", code: -1)
        }
        
        print("Sending message to chat: \(chatId)")
        print("Current user: \(user.id ?? "nil")")
        
        let message = Message(
            chatId: chatId,
            senderId: user.id!,
            senderName: user.username,
            content: content,
            timestamp: Date()
        )
        
        do {
            try await db.collection("messages").addDocument(from: message)
            print("Message sent successfully")
        } catch {
            print("Error sending message: \(error.localizedDescription)")
            throw error
        }
    }
    
    func observeMessages(chatId: String, completion: @escaping ([Message]) -> Void) {
        print("Starting to observe messages for chat: \(chatId)")
        
        db.collection("messages")
            .whereField("chatId", isEqualTo: chatId)
            .order(by: "timestamp")
            .addSnapshotListener { [weak self] snapshot, error in
                if let error = error {
                    print("Error observing messages: \(error.localizedDescription)")
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    print("No documents in snapshot")
                    return
                }
                
                print("Received \(documents.count) messages")
                let messages = documents.compactMap { document -> Message? in
                    do {
                        return try document.data(as: Message.self)
                    } catch {
                        print("Error decoding message: \(error.localizedDescription)")
                        return nil
                    }
                }
                
                DispatchQueue.main.async {
                    completion(messages)
                }
            }
    }
    
    func observeChats(completion: @escaping ([Chat]) -> Void) {
        guard let userId = currentUser?.id else {
            print("No current user for observing chats")
            return
        }
        
        print("Observing chats for user: \(userId)")
        
        db.collection("chats")
            .whereField("members", arrayContains: userId)
            .addSnapshotListener { [weak self] snapshot, error in
                if let error = error {
                    print("Error observing chats: \(error.localizedDescription)")
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    print("No documents in chats snapshot")
                    return
                }
                
                print("Received \(documents.count) chats")
                let chats = documents.compactMap { try? $0.data(as: Chat.self) }
                
                DispatchQueue.main.async {
                    completion(chats)
                }
            }
    }
} 
