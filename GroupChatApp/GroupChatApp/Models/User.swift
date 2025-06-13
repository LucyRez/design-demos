//
//  User.swift
//  GroupChatApp
//
//  Created by Lucy Rez on 03.06.2025.
//

import Foundation
import FirebaseFirestore

struct User: Identifiable, Codable {
    @DocumentID var id: String?
    let email: String
    let username: String
    var profileImageURL: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case email
        case username
        case profileImageURL
    }
} 
