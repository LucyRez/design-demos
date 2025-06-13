//
//  Message.swift
//  GroupChatApp
//
//  Created by Lucy Rez on 03.06.2025.
//

import Foundation
import FirebaseFirestore

struct Message: Identifiable, Codable, Equatable {
    @DocumentID var id: String?
    let chatId: String
    let senderId: String
    let senderName: String
    let content: String
    let timestamp: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case chatId
        case senderId
        case senderName
        case content
        case timestamp
    }
    
    static func == (lhs: Message, rhs: Message) -> Bool {
        return lhs.id == rhs.id &&
               lhs.chatId == rhs.chatId &&
               lhs.senderId == rhs.senderId &&
               lhs.senderName == rhs.senderName &&
               lhs.content == rhs.content &&
               lhs.timestamp == rhs.timestamp
    }
}
