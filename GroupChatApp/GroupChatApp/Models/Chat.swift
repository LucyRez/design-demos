//
//  Untitled.swift
//  GroupChatApp
//
//  Created by Lucy Rez on 03.06.2025.
//


import Foundation
import FirebaseFirestore

struct Chat: Identifiable, Codable {
    @DocumentID var id: String?
    let name: String
    let joinCode: String
    let createdAt: Date
    var members: [String] // Array of user IDs
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case joinCode
        case createdAt
        case members
    }
}
